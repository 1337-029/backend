.PHONY: init test-ignore up down dev r-web r-db

.ONESHELL:

COMPOSE_DIR = ./
COMPOSE_PATH = $(COMPOSE_DIR)docker-compose.yml

help:
	@ #TODO


init:
	@if [[ -d .envs ]]; then
	@	if [[ -f .envs/docker.env ]]; then
	@		echo ".envs/docker.env file already exists"
	@	else
	@		echo; # TODO: create empty env file with keys
	@	fi
	@fi

dev:
	@poetry install
	#TODO
	#@pre-commit install -t=pre-commit -t=pre-push

r-web:
	@ docker-compose -f $(COMPOSE_PATH) restart web

r-db:
	@ docker-compose -f $(COMPOSE_PATH)  restart db

up:
	@ docker-compose -f $(COMPOSE_PATH) up --build

down:
	@ docker-compose -f $(COMPOSE_PATH) down

test-ignore:
	@cat <<EOF > Dockerfile.build-context
	@FROM busybox
	@COPY $(COMPOSE_DIR) /build-context
	@WORKDIR /build-context
	@CMD find .
	@EOF
	@docker build -f Dockerfile.build-context -t build-context .
	@docker run --rm -it build-context
	@rm Dockerfile.build-context
