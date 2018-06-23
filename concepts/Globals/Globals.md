# グローバル変数

### 概要

利便性のため、Sailsはいくつかのグローバル変数を公開しています。デフォルトでは、アプリケーションの[モデル](https://sailsguides.jp/doc/reference/models)、[サービス](https://sailsguides.jp/doc/reference/services)、グローバルの`sails`オブジェクトはすべてグローバルスコープで使用可能です。つまり、Sailsが[起動している限り](https://github.com/balderdashy/sails/tree/master/lib/app)、バックエンドコードのどこでも参照することができます。

Sailsのコアには、グローバル変数に依存するものは何もありません。Sailsで公開されているすべてのグローバル変数は、`sails.config.globals`（通常は`config/globals.js`で設定されています）で無効化することができます。


### アプリケーションオブジェクト（`sails`）

ほとんどの場合、`sails`オブジェクトをグローバルでアクセス可能にしたいと思うでしょう。そうすることでアプリケーションコードをよりキレイにできます。しかし、すべてのグローバル変数を無効化する必要がある場合、リクエストオブジェクト（`req`）から`sails`へアクセスすることが可能です。

### モデルとサービス

アプリケーションの[モデル](https://sailsguides.jp/doc/reference/models)と[サービス](https://sailsguides.jp/doc/reference/services)は、それらの`globalId`を使って公開されています。例えば、モデルが`api/models/Foo.js`というファイルに定義されていた場合、`Foo`というグローバル変数でアクセス可能です。またサービスが`api/services/Baz.js`で定義されていた場合、`Baz`としてアクセス可能です。

### Async（`async`）とLodash（`_`）

Sailsは他にも[lodash](http://lodash.com)のインスタンスを`_`、[async](https://github.com/caolan/async)のインスタンスを`async`として公開しています。これらの良く使われているユーティリティはデフォルトで提供されているので、`npm install`で新規のプロジェクトで毎回インストールする必要はありません。ほかのグローバル変数と同様、それらは無効化できます。

<docmeta name="displayName" value="Globals">
<docmeta name="displayName_ja" value="グローバル変数">
