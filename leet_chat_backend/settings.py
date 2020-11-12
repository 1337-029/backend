from distutils.util import strtobool
from os import environ, path
from pathlib import Path

###############
# Directories #
###############

BASE_DIR = Path(__file__).resolve().parent.parent

############
# Security #
############

SECRET_KEY = environ.get("SECRET_KEY")
DEBUG = int(environ.get("DEBUG", 1))
ALLOWED_HOSTS = environ.get("ALLOWED_HOSTS", "*").split(" ")

########
# Apps #
########

INSTALLED_APPS = [
    "baton",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "apps.api_docs",
    "baton.autodiscover",
]

if DEBUG:
    INSTALLED_APPS.append("django_extensions")

#########
# ADMIN #
#########

AUTHOR = "Dhvcc"
ORG_URL = "https://github.com/1337-029"
REPO_URL = ORG_URL + "/backend"
ISSUE_URL = REPO_URL + "/issues"

BATON = {
    "SITE_HEADER": "Leet chat",
    "SITE_TITLE": "Leet chat",
    "INDEX_TITLE": "Site administration",
    "SUPPORT_HREF": ISSUE_URL,
    "COPYRIGHT": f"copyright © 2020 <a href=\"{ORG_URL}\">{AUTHOR}</a>",
    "POWERED_BY": f"<a href=\"{ORG_URL}\">{AUTHOR}</a>",
    "CONFIRM_UNSAVED_CHANGES": True,
    "SHOW_MULTIPART_UPLOADING": True,
    "ENABLE_IMAGES_PREVIEW": True,
    "CHANGELIST_FILTERS_IN_MODAL": True,
    "CHANGELIST_FILTERS_ALWAYS_OPEN": False,
    "MENU_ALWAYS_COLLAPSED": False,
    "MENU_TITLE": "Administration panel",
    "GRAVATAR_DEFAULT_IMG": "identicon",
}

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
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "NAME": environ.get("DATABASE_NAME"),
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
if not DEBUG:
    # AWS
    DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
    STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
    AWS_ACCESS_KEY_ID = environ.get("AWS_ACCESS_KEY_ID")
    AWS_SECRET_ACCESS_KEY = environ.get("AWS_SECRET_ACCESS_KEY")
    AWS_STORAGE_BUCKET_NAME = environ.get("AWS_STORAGE_BUCKET_NAME")
    AWS_S3_ADDRESSING_STYLE = "virtual"

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
