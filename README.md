# Docker-Django test

DockerでDjangoのプロダクション環境構築についてテストしたリポジトリです。

DjangoをuWSGIから起動しnginxからアクセスを行います。また、nginxコンテナはメディア用とソケット用をそれぞれ起動します。

もし本番環境で用いる場合、Djangoプロジェクトは必ずディレクトリごと入れ替えてから使用してください。

また、当リポジトリを利用したことによる責任を負うことはできません。自己責任でご利用ください。

## 設定

テストで使う場合はそのままお使いください。

もし任意のDjangoプロジェクトを使用する場合は、./dockerized_project/にコピーしてください。

docker-compose.ymlの以下を変更する必要があると思います。

* データベースの認証情報
* uwsgi_conf.iniのDJANGO_SETTINGS_MODULE

uWSGIの設定については uwsgi_conf.ini を参照してください。

## 起動

検証環境：Windows 10 Education 1803 64bit

※Windowsの場合、dockerでShared Driveの設定が行われている必要があります

```
git clone https://github.com/Sakaki/docker_django_test.git
cd docker_django_test
docker-compose up -d
```

Djangoプロジェクトは初期状態なのでほとんど何もできませんが、migrateを実行すれば http://localhost:5000/admin から[管理画面](http://localhost:5000/admin)にアクセスできます。

## Migrate

```
$ docker-compose exec uwsgi /bin/ash
/code # source /venv/bin/activate
(venv) /code # python manage.py migrate --settings=dockerized_project.settings.production
```

createsuperuserやmakemigrationsも同様の方法で行えます。

## 参考

* [How to use Django with uWSGI](https://docs.djangoproject.com/en/2.0/howto/deployment/wsgi/uwsgi/)
* [A Production-ready Dockerfile for Your Python/Django App](https://www.caktusgroup.com/blog/2017/03/14/production-ready-dockerfile-your-python-django-app/)
* [Scaling Django](https://djangobook.com/scaling-django/)

## TODO

* 開発用（development.py）が利用できるよう設定
