##########
# Config #
##########

.PHONY: help init dev \
 		test check fix \
 		up down restart-web restart-db \
 		test-ignore

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
	@if [[ -f .envs/prod/django.env ]]; then
	@	echo ".envs/prod/django.env file already exists"
	@else
	@	echo; # TODO: create empty env file with keys
	@fi

dev:
	@mkdir .envs .envs/dev
	@poetry install
	#TODO
	@#pre-commit install -t=pre-commit -t=pre-push

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
	@autoflake . --recursive --in-place --exclude=__init__.py,build,dist,.git,.eggs,migrations,venv
	@echo;
	@echo "isort"
	@echo "====="
	@isort .

##################
# Docker compose #
##################

restart-web:
	@docker-compose -f $(COMPOSE_PATH) restart web

restart-db:
	@docker-compose -f $(COMPOSE_PATH)  restart db

up:
	@docker-compose -f $(COMPOSE_PATH) up --build -d

down:
	@docker-compose -f $(COMPOSE_PATH) down

##############
# Dockerfile #
##############

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
