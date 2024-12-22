compose/build:
	docker compose build --no-cache

compose/build/release:
	docker compose -f docker-compose.release.yml build --no-cache

compose/up: front/node_modules
	@{ \
      while ! curl --fail --silent --head http://localhost:8080; do \
        echo "Waiting for the service to be ready..."; \
        sleep 1; \
      done; \
      if command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:8080; \
	  elif command -v open > /dev/null; then \
		open http://localhost:8080; \
	  else \
	    echo ""; \
	    echo "============================================"; \
	    echo " SERVICE IS READY "; \
	    echo " Please open http://localhost:8080 in your browser "; \
	    echo "============================================"; \
	    echo ""; \
	  fi; \
    } & \
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

front/node_modules:
	mkdir front/node_modules

typecheck:
	docker compose exec front npm run typecheck

check: check/go check/front

check/go:
	docker compose exec app go fmt ./...

check/front:
	make typecheck
	docker compose exec front npx @biomejs/biome check --write --unsafe

test: test/front

test/front:
	docker compose exec front-test npm run test/ci

test/front/watch:
	npm run test --prefix front
