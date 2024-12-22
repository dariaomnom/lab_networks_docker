FROM python:3.11-alpine

RUN apk update && apk add --no-cache \
    build-base \
    libffi-dev \
    postgresql-dev \
    libjpeg-turbo-dev \
    zlib-dev \
    musl-dev \
    && pip install --upgrade pip

WORKDIR /app/yatube_api

COPY requirements.txt .

RUN pip install -r requirements.txt && rm -rf /root/.cache

RUN adduser -D appuser
USER appuser

COPY . .

EXPOSE 8000
ENV DJANGO_SETTINGS_MODULE=yatube_api.settings

CMD ["sh", "-c", "python manage.py migrate && gunicorn yatube_api.wsgi:application --bind 0.0.0.0:8000"]
