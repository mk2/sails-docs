# Gruntの無効化

SailsでGrunt統合を無効化するには、単にGruntfileを削除（そして[`tasks/`](https://sailsguides.jp/doc/anatomy/tasks)フォルダを削除）するだけです。また、Gruntフックも無効化することができます。次のように`.sailsrc`のフックで、`grunt`プロパティを`false`に設定するだけです。

```json
{
    "hooks": {
        "grunt": false
    }
}
```

### SASSやAngular、クライアントサイドのJadeテンプレートなどのために、カスタマイズすることはできますか？

はい！`tasks/`ディレクトリにある適切なgruntタスクを置き換えるか、新しいタスクを追加するだけです。例として、[SASS](https://github.com/sails101/using-sass)のようにします。

デフォルトのWebフロントエンドは必要でないが、もし他の目的でGruntを使用したい場合は、プロジェクトのアセットフォルダを削除し`tasks/register/`と`tasks/config/`フォルダからフロントエンド向けのタスクを取り除くだけです。また`sails new myCoolApi --no-frontend`を実行することで、アセットフォルダとフロントエンド向けのGruntタスクを省略したプロジェクトを生成することもできます。`sails-generate-frontend`モジュールをコミュニティの代替ジェネレータと置き換えるか、[自分独自のジェネレーター](https://github.com/balderdashy/sails-generate-generator)を作ることもできます。これにより、ネイティブiOSアプリ、Androidアプリ、Cordovaパウリ、SteroidsJSアプリのボイラープレートを`sails new`によって作成することができます。


<docmeta name="displayName" value="Gruntを無効化する">

### 注意

上記のおgruntフックを取り除く場合、アセットを提供するために`.sailsrc`の中で次のように指定する必要があります。そうしないとすべてのアセットは`404`を返してしまいます。

```json
{
    "paths": {
        "public": "assets"
    }
}
```
