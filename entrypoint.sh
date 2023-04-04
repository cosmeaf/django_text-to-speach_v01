#!/bin/bash

set -e

# Adicionar configuração para herdar o host físico
export DJANGO_ALLOWED_HOSTS=$(echo $CAPROVER_VIRTUAL_HOST | sed -E 's/,[^,]*$//; s/^([^,]*),/\1 /; s/,/ /g')

# Adicionar configuração para herdar a certificação SSL
export DJANGO_SECURE_SSL_REDIRECT=true
export DJANGO_SECURE_PROXY_SSL_HEADER="HTTP_X_FORWARDED_PROTO=https"
export DJANGO_SESSION_COOKIE_SECURE=true
export DJANGO_CSRF_COOKIE_SECURE=true

# Rodar as migrações do banco de dados
python manage.py migrate

# Iniciar a aplicação
gunicorn --workers 2 app.wsgi -b 0.0.0.0:8000 --log-level debug --access-logfile /var/log/gunicorn/access.log
