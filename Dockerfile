# This Dockerfile is based on https://www.caktusgroup.com/blog/2017/03/14/production-ready-dockerfile-your-python-django-app/
FROM python:3.5-alpine

# Copy in your requirements file
ADD requirements.txt /requirements.txt

# Install build deps, then run `pip install`, then remove unneeded build deps all in a single step. Correct the path to your production requirements file, if needed.
RUN set -ex \
    && apk add --no-cache \
            gcc \
            make \
            libc-dev \
            musl-dev \
            linux-headers \
            mariadb-dev \
            pcre-dev
RUN python -m venv /venv
RUN /venv/bin/pip install -U pip
RUN /bin/sh -c "/venv/bin/pip install --no-cache-dir -r /requirements.txt"
 
# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
RUN mkdir /code/
WORKDIR /code/
ADD dockerized_project /code/
ADD start_uwsgi.sh /code/
ADD uwsgi_conf.ini /code/
RUN mkdir -p /code/dockerized_project/static

# uWSGI will listen on this port
EXPOSE 12345
 
# Add any custom, static environment variables needed by Django or your settings file here:
ENV DJANGO_SETTINGS_MODULE=dockerized_project.settings.production

CMD ["sh", "/code/start_uwsgi.sh"]
