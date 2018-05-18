# Docker-Django test

DockerでDjangoのプロダクション環境を動かします（実験的な意味合いが強いです）。

もし本番環境で用いる場合、Djangoプロジェクトは必ずディレクトリごと入れ替えてから使用してください。

また、当リポジトリを利用したことによる責任を負うことはできません。自己責任でご利用ください。

## 設定

テストで使う場合はそのままお使いください。

もし任意のDjangoプロジェクトを使用する場合は、./dockerized_project/にコピーしてください。

docker-compose.ymlの以下を変更する必要があると思います。

* データベースのログイン情報
* uwsgiのDJANGO_SETTINGS_MODULE

## 起動

```
docker-compose up -d
```

## Migrate

```
$ docker-compose exec -it uwsgi /bin/ash
/code # source /venv/bin/activate
(venv) /code # python manage.py migrate --settings=dockerized_project.settings.production
```

## TODO

* 開発用（development.py）の設定
