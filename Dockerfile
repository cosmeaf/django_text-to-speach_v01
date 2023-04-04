# pull the official base image
FROM python:3-alpine

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set work directory
WORKDIR /app

RUN apk add --no-cache --virtual .build-deps gcc musl-dev && \
    apk add --no-cache mariadb-dev build-base mariadb-client && \
    apk add --no-cache tzdata

# TIME ZONE
ENV TZ="America/Sao_Paulo"

# install dependencies
COPY ./requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

# copy project
COPY . /app

# copy the cron file
# COPY ./cron /etc/cron.d/cron
# RUN chmod 0644 /etc/cron.d/cron
# RUN crontab /etc/cron.d/cron
# RUN touch /var/log/cron.log

# exclude files from the Docker image
COPY .dockerignore /app/

# create the log directory for gunicorn
RUN mkdir -p /var/log/gunicorn

# set ownership to the user with uid 1000
RUN chown -R 1000:1000 /var/log/gunicorn

# start the app using gunicorn #
CMD ["gunicorn", "--workers", "2", "app.wsgi", "-b", "0.0.0.0:8000", "--log-level", "debug", "--access-logfile", "/var/log/gunicorn/access.log"]