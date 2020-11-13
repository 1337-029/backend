###
# Base image with slim python3.8 and a basic setup
###
FROM python:3.8-slim as base

RUN apt-get update && apt-get install -y gcc libffi-dev g++

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

###
# Builder image. Install poetry, create and populate venv
###
FROM base as builder

ENV POETRY_VERSION=1.1.4

RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock Makefile ./
RUN apt-get -y install make
RUN . /venv/bin/activate && make init

###
# Final image that will contain only venv and app
###
FROM base as final

COPY --from=builder /venv /venv

COPY docker-entrypoint.sh manage.py ./
COPY leet_chat_backend ./leet_chat_backend
COPY apps ./apps

RUN chmod +x docker-entrypoint.sh

EXPOSE 8000

CMD ["./docker-entrypoint.sh"]
