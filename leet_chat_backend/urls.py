from baton.autodiscover import admin
from django.urls import include, path

urlpatterns = [
    # Admin
    path("admin/", admin.site.urls),
    path("baton/", include("baton.urls")),
    # API docs
    path("", include("apps.api_docs.urls")),
    # API Auth
    path("", include("apps.auth.urls")),
]
