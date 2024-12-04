FROM node:22.11.0-alpine3.20 AS node-base

WORKDIR /app

COPY front/package*json front/tsconfig.json front/vite.config.ts ./
RUN npm ci

FROM node-base AS node-dev

COPY front .

EXPOSE 3000

CMD ["npm", "run", "dev"]

FROM node:22.11.0 AS node-dev-test

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

FROM golang:1.23.4-alpine3.20 AS base

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

FROM alpine:3.20 AS release

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/echo-server /usr/local/bin/echo-server

EXPOSE 1323

USER appuser

CMD ["echo-server"]

FROM nginx:1.26.2 AS nginx-base

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM nginx-base AS nginx-dev

COPY nginx/templates/proxy.local.conf.template /etc/nginx/templates/proxy.conf.template

FROM nginx-base AS nginx-release

COPY nginx/templates/proxy.release.conf.template /etc/nginx/templates/proxy.conf.template

COPY --from=node-builder /app/build /usr/share/nginx/html/build
COPY --from=node-builder /app/public /usr/share/nginx/html/public
