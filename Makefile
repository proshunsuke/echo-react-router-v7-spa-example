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

shell/front:
	docker compose exec front /bin/sh

run/app:
	docker compose run app /bin/sh

run/front:
	docker compose run front /bin/sh

build/front:
	docker compose exec front npm run build

typecheck:
	docker compose exec front npm run typecheck

check: check/go check/front

check/go:
	docker compose exec app go fmt ./...

check/front:
	make typecheck
	docker compose exec front npx @biomejs/biome check --write --unsafe app

test: test/front/ci

test/front/ci:
	docker compose exec front-test npm run test/ci

test/front/watch:
	npm run test --prefix front
