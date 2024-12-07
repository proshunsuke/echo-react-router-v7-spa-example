FROM node:22.11.0-alpine3.20@sha256:b64ced2e7cd0a4816699fe308ce6e8a08ccba463c757c00c14cd372e3d2c763e AS node-base

WORKDIR /app

COPY front/package*json front/tsconfig.json front/vite.config.ts ./
RUN npm ci

FROM node-base AS node-dev

COPY front .

EXPOSE 3000

CMD ["npm", "run", "dev"]

FROM node:22.11.0@sha256:ec878c763e9fad09d22aae86e2edcb7a05b397dfe8411c16e2b90158d595e2ce AS node-dev-test

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libatomic1

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY front .
RUN npm i

RUN npx playwright install && \
    npx playwright install-deps

FROM node-base AS node-builder

COPY front .

RUN npm run build

FROM golang:1.23.2-alpine3.20@sha256:9dd2625a1ff2859b8d8b01d8f7822c0f528942fe56cfe7a1e7c38d3b8d72d679 AS base

WORKDIR /app

RUN apk add --no-cache git

COPY server/go.mod server/go.sum ./
RUN go mod download

FROM base AS dev

RUN go install github.com/air-verse/air@latest

COPY server .

CMD ["air", "-c", ".air.toml"]

FROM base AS builder

COPY server .

RUN go build -ldflags="-s -w" -o echo-server ./server.go

FROM alpine:3.20@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a AS release

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/echo-server /usr/local/bin/echo-server

EXPOSE 1323

USER appuser

CMD ["echo-server"]

FROM nginx:1.26.2@sha256:1a476ecee5324eaa2f5d8d46b8416293bc52b8b9306378e44a912508ee13b75e AS nginx-base

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM nginx-base AS nginx-dev

COPY nginx/templates/proxy.local.conf.template /etc/nginx/templates/proxy.conf.template

FROM nginx-base AS nginx-release

COPY nginx/templates/proxy.release.conf.template /etc/nginx/templates/proxy.conf.template

COPY --from=node-builder /app/build /usr/share/nginx/html/build
COPY --from=node-builder /app/public /usr/share/nginx/html/public
