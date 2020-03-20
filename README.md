# p4triggerdemo
トリガスクリプトのテスト用Dockerイメージを作成するためのファイル群を管理するリポジトリです。

`docker`または`docker-compose`を使用して次のようにしてビルドしてください。

```
例: dockerを使用
    docker build -t p4triggerdemo .

例: docker-composeを使用
    docker-compose build
```



ベースになるPythonのバージョンをARGで調整できるようにしています。

Python 3.7をデフォルトにしていますが、Python 3.8を使用する場合は次のようにしてビルドしてください。

```
例: dockerを使用
    docker build -t p4triggerdemo .

例：docker-composeを使用
    docker-compose build
```

