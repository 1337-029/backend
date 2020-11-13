from baton.autodiscover import admin
from django.urls import path, include
from rest_framework.authtoken import views

urlpatterns = [
    # Admin
    path('admin/', admin.site.urls),
    path('baton/', include('baton.urls')),
    # API docs
    path("", include("apps.api_docs.urls")),
    # API Auth
    path("api-token-auth/", views.ObtainAuthToken.as_view(), name='api-token-auth'),
]
