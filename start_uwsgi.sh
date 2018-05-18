#!/bin/sh

/venv/bin/python manage.py collectstatic --noinput
/venv/bin/uwsgi --ini uwsgi_conf.ini
