from distutils.util import strtobool
from os import environ
from pathlib import Path

###############
# Directories #
###############

BASE_DIR = Path(__file__).resolve().parent.parent

############
# Security #
############

SECRET_KEY = environ.get("SECRET_KEY", "3oGi5RQhGsJGx4sm")
DEBUG = strtobool(environ.get("DEBUG", "True"))
ALLOWED_HOSTS = environ.get("ALLOWED_HOSTS", "").split(",")

########
# Apps #
########

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django_extensions",
]

##############
# Middleware #
##############

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

############
# Database #
############

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2"
        if environ.get("DATABASE_HOST")
        else "django.db.backends.sqlite3",
        "NAME": environ.get("DATABASE_NAME") or BASE_DIR / "db.sqlite3",
        "HOST": environ.get("DATABASE_HOST"),
        "PORT": environ.get("DATABASE_PORT"),
        "USER": environ.get("DATABASE_USER"),
        "PASSWORD": environ.get("DATABASE_PASSWORD"),
    }
}

##########
# Server #
##########

ROOT_URLCONF = "leet_chat_backend.urls"
WSGI_APPLICATION = "leet_chat_backend.wsgi.application"

#################
# Authorization #
#################

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

###########
# Serving #
###########

STATIC_URL = "/static/"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / ""],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

################
# Localization #
################

LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_L10N = True
USE_TZ = True
