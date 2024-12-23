FROM python:3.11-alpine as builder

RUN apk update && apk add --no-cache \
    build-base \
    libffi-dev \
    postgresql-dev \
    libjpeg-turbo-dev \
    zlib-dev \
    musl-dev

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt

FROM python:3.11-alpine

RUN apk add --no-cache \
    libffi \
    postgresql-libs \
    libjpeg-turbo \
    zlib

WORKDIR /app/yatube_api

COPY --from=builder /install /usr/local

RUN adduser -D appuser
USER appuser

COPY . .

EXPOSE 8000
ENV DJANGO_SETTINGS_MODULE=yatube_api.settings

CMD ["sh", "-c", "python manage.py migrate && gunicorn yatube_api.wsgi:application --bind 0.0.0.0:8000"]