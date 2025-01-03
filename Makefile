compose/build:
	docker compose build --no-cache

compose/build/release:
	docker compose -f docker-compose.release.yml build --no-cache

compose/up:
	docker compose up

compose/up/release:
	docker compose -f docker-compose.release.yml up

shell/app:
	docker compose exec app /bin/sh

run/app:
	docker compose run app /bin/sh

dev/front: install/front
	cd front && npm run dev

install/front:
	cd front && npm ci

check: check/go check/front

check/go:
	docker compose exec app go fmt ./...

check/front:
	cd front && npm run typecheck
	cd front && npx @biomejs/biome check --write --unsafe

test: test/front

test/front:
	docker compose exec front-test sh -c "npm ci && npm run test/ci"

test/front/watch:
	cd front && npm ci && npm run test
