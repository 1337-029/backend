from django.urls import path

from apps.api_docs import views

urlpatterns = [
    path("openapi/", views.schema_view, name="openapi"),
    path("openapi-json/", views.json_schema_view, name="openapi-json"),
    path("", views.api_docs_view, name="api-docs-view")
]
