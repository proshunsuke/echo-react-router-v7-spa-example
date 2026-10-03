FROM node:22.16.0-alpine3.20@sha256:2289fb1fba0f4633b08ec47b94a89c7e20b829fc5679f9b7b298eaa2f1ed8b7e AS node-base

FROM node:22.23.3@sha256:363e1587494626837fa7f9a23bdb453d13b0ff3c67c705c2805cfc69c2d2fad7 AS node-dev-test

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

FROM alpine:3.24@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS release

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/echo-server /usr/local/bin/echo-server

EXPOSE 1323

USER appuser

CMD ["echo-server"]

FROM nginx:1.31.6@sha256:908dc23e643a1447dbfb2e189ed268bfde6a51a5bf9a34d3dd3440a24f58ccf7 AS nginx-base

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM nginx-base AS nginx-dev

COPY nginx/templates/proxy.local.conf.template /etc/nginx/templates/proxy.conf.template

FROM nginx-base AS nginx-release

COPY nginx/templates/proxy.release.conf.template /etc/nginx/templates/proxy.conf.template

COPY --from=node-builder /app/build /usr/share/nginx/html/build
