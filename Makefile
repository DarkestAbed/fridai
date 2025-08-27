# Monorepo Makefile (v2.0.0-vibe)

OWNER?=thedarkestabed
TAG?=v2.0.0-vibe

.PHONY: help
help:
	@echo "Targets: build, compose-up, compose-down, test, bootstrap, package, clean"

build:
	docker build -t ghcr.io/$(OWNER)/task-platform-backend:$(TAG) backend
	docker build -t ghcr.io/$(OWNER)/task-platform-frontend:$(TAG) frontend
	docker build -t ghcr.io/$(OWNER)/task-platform-worker:$(TAG) worker

compose-up:
	docker compose up --build

compose-down:
	docker compose down --remove-orphans --rmi "local" --volumes

test:
	docker compose run --rm backend pytest -q

bootstrap:
	docker compose run --rm backend python bootstrap.py

package:
	cd /mnt/data && zip -r task-platform-v2.0.0-vibe.zip task-platform-v2.0.0-vibe

clean:
	docker compose down -v || true
	rm -f /mnt/data/task-platform-v2.0.0-vibe.zip || true
