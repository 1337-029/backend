from django.urls import path
from rest_framework.authtoken import views

urlpatterns = [
    # TODO: Add JWT?
    path("api-token-auth/", views.obtain_auth_token, name="api-token-auth"),
]
