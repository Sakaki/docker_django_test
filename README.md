# Docker-Django

DockerでDjangoのプロダクション環境を構築する際のスケルトンです。

## 使い方（テスト環境）

### Dockerを使わず起動

```bash
pip install django
cd project
python manage.py runserver --settings=project.settings.development 0.0.0.0:5000
```

### Dockerで起動

```bash
docker-compose build uwsgi
docker-compose up
```

Djangoプロジェクトは初期状態なのでほとんど何もできませんが、migrateを実行すれば http://localhost:5000/admin から[管理画面](http://localhost:5000/admin)にアクセスできます。

データは`./docker_volumes`に保存されます。

## 使い方（本番環境）

もし本番環境で用いる場合、 **Djangoプロジェクト(./project)は必ずディレクトリごと入れ替えてから使用してください。** また、当リポジトリを利用したことによる責任を負うことはできません。自己責任でご利用ください。

```bash
rm -r project
django-admin startproject project
```

設定ファイルを開発用と本番用で分割します。

```bash
mkdir project/project/settings
mv project/project/settings.py project/project/settings/development.py
cp project/project/settings/development.py project/project/settings/production.py
```

`project/project/settings/production.py`を編集します。

```python
# 中略
DEBUG = False

ALLOWED_HOSTS = ["localhost", "127.0.0.1"]

# 中略
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'db_name',
        'USER': 'db_user',
        'PASSWORD': 'db_password',
        'HOST': 'db',
        'PORT': '3306',
    }
}

# 中略
LANGUAGE_CODE = 'ja'

TIME_ZONE = 'Asia/Tokyo'

# 中略
# 最終行に
STATIC_ROOT = '/code/project/static'
```

DATABASESの値は適当なものに変更してください。

続いて、`docker-compose.yml`を編集します。

MYSQLのパスワードなどを変更してください。

```yml
  db:
    image: mysql:5.7
    command: mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci
    volumes:
      - ./docker_volumes/mysql:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_DATABASE=db_name
      - MYSQL_USER=db_user
      - MYSQL_PASSWORD=db_password
```

以上の設定が完了したら、

```bash
docker-compose up -d
```

で実行できます。

uWSGIの設定については uwsgi_conf.ini を参照してください。

## Migrate

```
$ docker-compose exec uwsgi /bin/ash
/code # source /venv/bin/activate
(venv) /code # python manage.py migrate --settings=dockerized_project.settings.production
```

createsuperuserやmakemigrationsも同様の方法で行えます。

### Djangoアプリケーションを作る際の注意点

当リポジトリはDjangoアプリケーションを作成していないため、**Migrationファイルを保存するためのボリューム設定を行っていません**。

Migrationsファイルのボリューム設定を行わずに運用を行うと、コンテナを削除して再起動した際にそれらのファイルが失われ、データベースの構造を変更する際にエラーが発生します。

ボリュームを設定するか、Migrationの後には`docker copy`で安全な場所にコピーするなど、必ずMigrationsファイルを保持できるような運用を行ってください。

## 参考

* [How to use Django with uWSGI](https://docs.djangoproject.com/en/2.0/howto/deployment/wsgi/uwsgi/)
* [A Production-ready Dockerfile for Your Python/Django App](https://www.caktusgroup.com/blog/2017/03/14/production-ready-dockerfile-your-python-django-app/)
* [Scaling Django](https://djangobook.com/scaling-django/)

## TODO

* 開発用（development.py）が利用できるよう設定
