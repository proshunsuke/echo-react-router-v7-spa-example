FROM node:22.16.0-alpine3.20@sha256:2289fb1fba0f4633b08ec47b94a89c7e20b829fc5679f9b7b298eaa2f1ed8b7e AS node-base

FROM node:22.23.4@sha256:18a6d90fd60542269850c80ca03b29b1d9b14d6b221ac7ee8e35b0d33ef904bd AS node-dev-test

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libatomic1

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY front /app/

RUN npm ci

RUN npx playwright install && \
    npx playwright install-deps

FROM node-base AS node-builder

WORKDIR /app

COPY front /app/

RUN npm ci

RUN npm run build

FROM golang:1.24.3-alpine3.20@sha256:9f98e9893fbc798c710f3432baa1e0ac6127799127c3101d2c263c3a954f0abe AS base

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

FROM alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS release

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/echo-server /usr/local/bin/echo-server

EXPOSE 1323

USER appuser

CMD ["echo-server"]

FROM nginx:1.31.8@sha256:5ab5b0b01097420873a3f3330f44248e34a3c2a3e8d5ee30658aeae8cb7435da AS nginx-base

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM nginx-base AS nginx-dev

COPY nginx/templates/proxy.local.conf.template /etc/nginx/templates/proxy.conf.template

FROM nginx-base AS nginx-release

COPY nginx/templates/proxy.release.conf.template /etc/nginx/templates/proxy.conf.template

COPY --from=node-builder /app/build /usr/share/nginx/html/build
