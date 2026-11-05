FROM python:3.11-slim

LABEL maintainer="devops-academia"
LABEL description="Aplicacion web - Curso DevOps"

WORKDIR /app

COPY app.py .

RUN useradd -m -u 1000 appuser \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["python", "-u", "app.py"]
