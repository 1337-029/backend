import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "leet_chat_backend.settings")

application = get_wsgi_application()
