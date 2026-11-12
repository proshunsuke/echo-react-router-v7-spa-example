FROM node:22.16.0-alpine3.20@sha256:2289fb1fba0f4633b08ec47b94a89c7e20b829fc5679f9b7b298eaa2f1ed8b7e AS node-base

FROM node:22.23.5@sha256:e13726ca604184d7a91fcacab1fc09eefd642dc28e79ac34e85540dd93b78cfb AS node-dev-test

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

FROM alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS release

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/echo-server /usr/local/bin/echo-server

EXPOSE 1323

USER appuser

CMD ["echo-server"]

FROM nginx:1.31.8@sha256:165ddde8751e75a1c907d24ef10d9f6deb08b57e0fe56caf67512486aff76d82 AS nginx-base

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM nginx-base AS nginx-dev

COPY nginx/templates/proxy.local.conf.template /etc/nginx/templates/proxy.conf.template

FROM nginx-base AS nginx-release

COPY nginx/templates/proxy.release.conf.template /etc/nginx/templates/proxy.conf.template

COPY --from=node-builder /app/build /usr/share/nginx/html/build
