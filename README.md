# p4triggerdemo
トリガスクリプトのテスト用Dockerイメージを作成するためのファイル群を管理するリポジトリです。



## Dockerイメージのビルド方法

`docker`または`docker-compose`を使用して次のようにしてビルドしてください。

```
例: dockerを使用
    docker build -t p4triggerdemo .

例: docker-composeを使用
    docker-compose build
```



## Dockerイメージの使用方法

`docker`または`docker-compose`を使用して次のようにして実行してください。

```
例: dockerを使用
    docker run -p 1666:1666 -itd p4triggerdemo

例: docker-composeを使用
    docker-compose up -d
```

1666ポートでHelix Coreが起動しますので、P4VなどのHelix Coreクライアントでアクセスします。

Helix Coreにはサンプルディポが登録されています。

また、すべてではないものの数多くのトリガを登録して、トリガの発動タイミングを調査できるようにしています。



## 登録済みトリガの挙動

### <u>登録済みトリガの確認</u>

`p4 -u bruno triggers`を実行すると、登録されているトリガを確認することができます。

例えば、change-submitトリガは以下の内容で登録されています。

```
test_change_submit change-submit //... "/opt/perforce/triggers/change-submit/change_submit.sh %user%"
```

この他の登録済みトリガは以下でも確認ができます。

| 種類                                                       | GitHub                                                       | マニュアル                                                   |
| ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| サブミット用トリガ<br />保留用トリガ<br />プッシュ用トリガ | [p4triggers_submit.txt](https://github.com/p4misc/p4triggerdemo/blob/master/triggers/p4triggers_submit.txt) | [サブミット用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.submits.html)<br />[保留用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.shelving.html)<br />[プッシュ用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.push.html) |
| フォーム用トリガ                                           | [p4triggers_form.txt](https://github.com/p4misc/p4triggerdemo/blob/master/triggers/p4triggers_form.txt) | [フォーム用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.forms.html) |
| コマンド用トリガ                                           | [p4triggers_command.txt](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.order.html) | [コマンド用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.order.html) |
| ジョブ用トリガ                                             | [p4triggers_fix.txt](https://github.com/p4misc/p4triggerdemo/blob/master/triggers/p4triggers_fix.txt) | [ジョブ用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.fixes.html) |
| ジャーナル用トリガ                                         | [p4triggers_journal.txt](https://github.com/p4misc/p4triggerdemo/blob/master/triggers/p4triggers_journal.txt) | [ジャーナル用トリガのマニュアル](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.journal.html) |

※ [上記以外の種類のトリガ](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/chapter.scripting.triggers.html)もありますが、テスト用Dockerイメージには含めませんでした。

※ コマンド用トリガを網羅しようとすると、コマンド数の倍のトリガを登録することになるため、sync branch change add edit open undo merge copy integrateのみを対象にして事前登録しています。



### <u>登録済みトリガの処理</u>

それぞれのトリガは、それぞれ異なる名称のシェルスクリプトを呼び出すようになっています。

また、シェルスクリプト名に対応する名称のログに足跡を残すようになっています。



例えば、本調査用Dockerイメージでは`change-submit`トリガが以下のように処理されます。

1. Helix Coreが`change-submit`イベントを発行する。

2. `change-submit`トリガが反応する。

   ```
   test_change_submit change-submit //... "/opt/perforce/triggers/change-submit/change_submit.sh %user%"
   ```

3. トリガの中で指定されている以下のコマンドが実行される。

   ```
   /opt/perforce/triggers/change-submit/change_submit.sh %user%
   ```

   ※ `%user%`はトリガスクリプト変数であり、トリガを実行したユーザアカウントに置き換えられます。
   ※ `%user%`のみを与えていますが、コマンドの処理に必要な[その他のトリガスクリプト変数](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.variables.html)を渡すことができます。

4. 実行されたコマンド`(change_submit.sh)`は、以下の処理で与えられたパラメータをファイルに出力する。

   ```
   #!/bin/bash
   echo $* >> "/opt/perforce/triggers/logs/change_submit.log"
   ```

   ※ コマンドの名称に対応する名称のログが出力されるようになっています（例: `change_submit.sh` → `/opt/perforce/triggers/logs/change_submit.log`）。
   



トリガごとに別々のログに情報が出力されるようになっているため、ログの更新状況を確認することでHelix Coreに対してどのような操作を行ったときに、どのトリガが反応するのかが分かるようになっています。



## トリガの調査方法

次の要領でトリガの調査を行います。

1. 起動したDockerコンテナにログインします。

   ```
   docker exec -it コンテナID /bin/bash
   ```

2. ログディレクトリに移動します。

   ```
   cd /opt/perforce/triggers/logs
   ```

3. Helix Coreクライアントを使ってトリガに反応させたい操作を行い、操作後にログディレクトリの内容を確認します。

   ```
   ls -al *.log
   ```

4. 出力されているログから、実行した操作と反応するトリガの関係を把握します。
   ※ コマンド用トリガについては、一部のコマンドしか登録していないため、不足がある場合は他のコマンドトリガを参考にしてトリガを追加してください。

5. ログの内容を`tail`コマンドで監視して、把握した関係どおりに動作しているのかを確認します。

   ```
   tail -f *.log
   ```

6. トリガスクリプトに渡したい情報が`%user%`以外に存在する場合は、[トリガスクリプト変数](https://www.toyo.co.jp/files/user/img/product/ss/help/perforce/r19.1/manuals/p4sag/Content/P4SAG/scripting.triggers.variables.html)を参考にしてパラメータを追加してください。
   追加する場合は、以下のコマンドを実行してトリガの設定を変更してください。

   ```
   p4 -u bruno triggers
   ```



## トリガスクリプトの追加方法

コマンド用トリガについては一部のコマンドしかトリガスクリプトを準備していません。

しかし、`/opt/perforce/triggers/create_command_trigger.sh`を使ってコマンド用トリガのエントリを増やすことができます。

追加方法は以下のとおりです。

1. `create_command_trigger.sh`内の以下の行を変更して、トリガを追加したいコマンド名を列挙します。

   ```
   TRIGGER_PATHS="sync branch change add edit open undo merge copy integrate"
   ```

2. 例えば、p4 delete、p4 reconcile、p4 cleanに反応させる場合は以下のように列挙します。

   ```
   TRIGGER_PATHS="delete reconcile clean"
   ```
   
3. 変更後に`create_command_trigger.sh`を実行すると列挙したコマンドに対応するトリガスクリプトが`/opt/perforce/triggers/command`の中に作成されます。

   ```
   cd /opt/perforce/triggers
   ./create_command_trigger.sh
   ```

4. 同時にトリガに追記する設定も`/opt/perforce/triggers/p4triggers_command.txt`に出力されるので、`p4 -u bruno triggers`コマンドを実行して追記します。





