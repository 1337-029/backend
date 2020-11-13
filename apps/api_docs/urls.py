from django.urls import path
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularRedocView,
    SpectacularSwaggerView
)

from django.shortcuts import render

urlpatterns = [
    # Schemas
    path("schema", SpectacularAPIView.as_view(), name='schema'),
    # Ui
    path("", lambda request: render(request, "api_docs/index.html"), name="api-docs-rapidoc"),
    path('swagger-ui/', SpectacularSwaggerView.as_view(url_name='schema'), name='api-docs-swagger-ui'),
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='api-docs-redoc'),
]
