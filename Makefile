##########
# Config #
##########

.PHONY: help init dev \
 		test check fix \
 		up down restart-web restart-db test-ignore

.ONESHELL:

COMPOSE_DIR = ./
COMPOSE_PATH = $(COMPOSE_DIR)docker-compose.yml

help:
	@ #TODO

##########################
# Project initialization #
##########################

init:
	@mkdir .envs .envs/prod
	@if [ -f .envs/prod/django.env ]; then echo ".envs/prod/django.env file already exists"
	@else cat <<EOF > .envs/prod/django.env
	@DEBUG=0
	@SECRET_KEY=
	@ALLOWED_HOSTS=""
	@
	@DATABASE_HOST=db
	@DATABASE_PORT=5432
	@DATABASE_NAME=
	@DATABASE_USER=
	@DATABASE_PASSWORD=
	@EOF
	@fi

	@if [ -f .envs/prod/aws.env ]; then echo ".envs/prod/aws.env file already exists"
	@else cat <<EOF > .envs/prod/aws.env
	@AWS_ACCESS_KEY_ID=
	@AWS_SECRET_ACCESS_KEY=
	@AWS_STORAGE_BUCKET_NAME=
	@AWS_S3_REGION_NAME=
	@AWS_S3_SIGNATURE_VERSION=
	@EOF
	@fi

	@if [ -f .envs/prod/postgres.env ]; then echo ".envs/prod/postgres.env file already exists"
	@else cat <<EOF > .envs/prod/postgres.env
	@POSTGRES_USER=postgres
	@POSTGRES_PASSWORD=
	@POSTGRES_DB=postgres
	@EOF
	@fi

	@poetry install --no-dev --no-root

dev:
	@mkdir .envs .envs/dev
	@if [ -f .envs/dev/django.env ]; then echo ".envs/dev/django.env file already exists"
	@else cat <<EOF > .envs/dev/django.env
	@DEBUG=1
	@SECRET_KEY=
	@ALLOWED_HOSTS="*"
	@
	@DATABASE_HOST=localhost
	@DATABASE_PORT=5432
	@DATABASE_NAME=
	@DATABASE_USER=
	@DATABASE_PASSWORD=
	@EOF
	@fi
	@poetry install
	@pre-commit install -t=pre-commit -t=pre-push

###############
# Code checks #
###############

test:
	@echo "pytest"
	@echo "======"
	@pytest

check:
	@echo "flake8"
	@echo "======"
	@python -m flake8

fix:
	@echo "black"
	@echo "====="
	@black .
	@echo;
	@echo "autoflake"
	@echo "========="
	@autoflake . --recursive --in-place --remove-all-unused-imports --remove-duplicate-keys \
				--exclude=__init__.py,build,dist,.git,.eggs,migrations,venv
	@echo;
	@echo "isort"
	@echo "====="
	@isort .

##########
# Docker #
##########

restart-web:
	@docker-compose -f $(COMPOSE_PATH) restart web

restart-db:
	@docker-compose -f $(COMPOSE_PATH)  restart db

up:
	@docker-compose -f $(COMPOSE_PATH) up --build -d

down:
	@docker-compose -f $(COMPOSE_PATH) down

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
