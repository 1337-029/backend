##########
# Config #
##########

COMPOSE_DIR = ./
COMPOSE_PATH = $(COMPOSE_DIR)docker-compose.yml

.PHONY: help prod dev all \
 		test check fix \
 		test-ignore show-build-files \
 		up down restart-web restart-db

.ONESHELL:

.DEFAULT: help
help:
	@echo "Project"
	@echo "======="
	@echo "make prod"
	@echo "	   init prod .envs and install dependencies without dev"
	@echo "make dev"
	@echo "	   init dev .envs, install all dependencies and init git hooks"
	@echo "make all"
	@echo "	   \"make prod\" and \"make dev\""
	@echo;
	@echo "Code checks"
	@echo "==========="
	@echo "make test"
	@echo "	   test code with pytest"
	@echo "make check"
	@echo "	   lint code with flake8"
	@echo "make fix"
	@echo "	   format code with black, autoflake and isort"
	@echo;
	@echo "Docker"
	@echo "======"
	@echo "make test-ignore"
	@echo "	   test local .dockerignore, output local files after build"
	@echo "make show-build-files"
	@echo "	   build Dockerfile and output WORKDIR files"
	@echo "make up"
	@echo "	   build and up containers in detached mode"
	@echo "make down / restart-web / restart-db"
	@echo "	   analogs to docker-compose commands"

##########################
# Project initialization #
##########################

define prod =
	@echo "Prod .envs"
	@echo "=========="
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

	@echo;
	@echo "Prod dependencies"
	@echo "================="
	@poetry install --no-dev --no-root
endef

define dev =
	@echo "Dev .envs"
	@echo "========="
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

	@echo;
	@echo "Dev dependencies"
	@echo "================"
	@poetry install --no-root

	@echo;
	@echo "Git hooks"
	@echo "========="
	@poetry run pre-commit install -t=pre-commit -t=pre-push
endef

prod:
	$(prod)

dev:
	$(dev)

all:
	@echo "Prod"
	@echo "===="
	$(prod)
	@echo;
	@echo "Dev"
	@echo "==="
	$(dev)

###############
# Code checks #
###############

test:
	@echo "pytest"
	@echo "======"
	@poetry run pytest

check:
	@echo "flake8"
	@echo "======"
	@poetry run flake8

fix:
	@echo "black"
	@echo "====="
	@poetry run black .
	@echo;
	@echo "autoflake"
	@echo "========="
	@poetry run autoflake . --recursive --in-place --remove-all-unused-imports --remove-duplicate-keys \
				--exclude=__init__.py,build,dist,.git,.eggs,migrations,venv
	@echo;
	@echo "isort"
	@echo "====="
	@poetry run isort .

##########
# Docker #
##########

restart-web:
	@docker-compose -f $(COMPOSE_PATH) restart web

restart-db:
	@docker-compose -f $(COMPOSE_PATH) restart db

up:
	@docker-compose -f $(COMPOSE_PATH) up --build -d

down:
	@docker-compose -f $(COMPOSE_PATH) down

show-build-files:
	@docker build -t test-dockerfile .
	@docker run --rm --entrypoint=/bin/sh test-dockerfile -c find .

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
