#!/bin/bash

function postgres_ready(){
python << END
import sys
import psycopg2
from os import environ

try:
    conn = psycopg2.connect(dbname=environ.get("DATABASE_NAME"), user=environ.get("DATABASE_USER"),
                            password=environ.get("DATABASE_PASSWORD"), host=environ.get("DATABASE_HOST"),
                            port=environ.get("DATABASE_PORT"))
except psycopg2.OperationalError as e:
    print(e)
    sys.exit(-1)
sys.exit(0)
END
}

source /venv/bin/activate

until postgres_ready; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 5
done

python manage.py migrate --no-input
#python manage.py flush --no-input
python manage.py runserver 0.0.0.0:8000
