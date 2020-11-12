from baton.autodiscover import admin
from django.urls import path, include

urlpatterns = [
    # Admin
    path('admin/', admin.site.urls),
    path('baton/', include('baton.urls')),
    # API docs
    path("", include("apps.api_docs.urls")),
]
