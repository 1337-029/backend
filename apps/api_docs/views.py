from django.shortcuts import render
from rest_framework.renderers import JSONOpenAPIRenderer
from rest_framework.schemas import get_schema_view

SCHEMA_TITLE = "Leet chat API"
SCHEMA_DESCRIPTION = "Leet chat backend API docs"

schema_view = get_schema_view(
    title=SCHEMA_TITLE,
    description=SCHEMA_DESCRIPTION,
)

json_schema_view = get_schema_view(
    title=SCHEMA_TITLE,
    description=SCHEMA_DESCRIPTION,
    renderer_classes=(JSONOpenAPIRenderer,)
)


def api_docs_view(request):
    return render(request, "api_docs/index.html")
