# 設定

### 概要

Sailsは[設定よりも規約](http://en.wikipedia.org/wiki/Convention_over_configuration)の考え方に忠実に従っていますが、時に応じてそれらの便利なデフォルトの動作をカスタマイズする方法を理解することが重要です。ほとんどすべてのSailsの規約には、必要に応じて調整または上書きできる設定オプションが付いています。

> 特定の設定を探していますか？Sailsで利用可能なすべての設定オプションへの完璧なガイドを参照するするには、上にある[Reference > Configuration](sailsjs.com/documentation/reference/configuration)を見てください。

Sailsアプリケーションは、[環境変数](http://en.wikipedia.org/wiki/Environment_variable)やコマンドライン引数を指定したり、ローカルファイルやグローバルの[`.sailsrc`ファイル](https://sailsjs.com/documentation/anatomy/.sailsrc)を変更したり、新しいプロジェクトの[`config/`](https://sailsjs.com/documentation/anatomy/config)フォルダにある設定ファイルを使用して[プログラマブルに設定する](https://github.com/mikermcneil/sails-generate-new-but-like-express/blob/master/templates/app.js#L15)ことができます。マージされ、アプリで使われている正規の設定は、実行時にグローバル変数である`sails`および`sails.config`として利用できます。

### 標準設定ファイル (`config/*`)

新しくSailsアプリケーションを作成すると、デフォルトで多くの設定ファイルが生成されます。これらのボイラープレートファイルには多数のインラインコメントが含まれており、ドキュメントとテキストエディタの間を行き来することなく、迅速なオンザフライリファレンスを提供するように設計されています。

ほとんどの場合、`sails.config`オブジェクトの最上位のキー（例えば`sails.config.views`）はアプリの特定の設定ファイル（例えば、`config/views.js`）に対応します。ただし、`config/`ディレクトリ内のファイル間で好きなように設定を配置することもできます。重要なのは、どのファイルではなく、設定の名前（キー）です。

例えば、`config/foo.js`という新しいファイルを追加するとします。

```js
// config/foo.js
// The object below will be merged into `sails.config.blueprints`:
module.exports.blueprints = {
  shortcuts: false
};
```

個々の設定オプションについての詳細なリファレンスとデフォルトのファイルについては、このセクションのリファレンスページをチェックするか、[アプリの構造](https://sailsjs.com/documentation/anatomy)にある["`config/`"](https://sailsjs.com/documentation/anatomy/config)を見て、高いレベルの概要を理解しましょう。

### 環境固有のファイル (`config/env/*`)

標準設定ファイルで指定された設定は、一般にすべての環境（開発、本番、テスト、など）で利用可能になります。もし特定の環境のみで有効にしたい設定がある場合は、特別な環境固有のファイルとフォルダを使用することができます。

* `/config/env/<environment-name>`フォルダ内に保存されたファイルは、Sailsが`<environment-name>`の環境で立ち上がったときにのみ、ロードされます。例えば、`config/env/production`に保存されたファイルは、本番環境でSailsが立ち上がった時にのみロードされます。

* `config/env/<environment-name>.js`として保存されたすべてのファイルは、`<environment-name>`の環境でSailsが立ち上がったときにのみロードされます。そして、環境固有のサブフォルダからすべての設定がロードされた後、その上にマージされます。例えば、`config/env/production.js`にある設定は、`config/env/production`フォルダのファイルにある設定よりも優先されます。

デフォルトでは、アプリケーションは「開発」環境で動作します。おすすめのアプリケーションの環境を変更する方法は、`NODE_ENV`環境変数を使うことです。

```
NODE_ENV=production node app.js
```

> `production`環境は特別です。あなたの設定によりますが、圧縮やキャッシュ、ミニフィケーションなどが利用できます。
>
> もし`config/local.js`を使っている場合は、そのファイルでエクスポートされた設定は、環境固有の設定ファイルより優先されます。

### `config/local.js`ファイル

`config/local.js`ファイルを使ってローカル環境用（ラップトップなど）にSailsアプリケーションを設定するかもしれません。このファイルにある設定は、[.sailsrc](https://sailsjs.com/documentation/concepts/configuration/using-sailsrc-files)を除く他のすべての設定ファイルより優先されます。ローカル環境での利用のみを目的としているため、バージョン管理下におくべきではありません（そのため、デフォルトの`.gitignore`ファイルには含まれています）。`local.js`を使ってローカルのデータベースの設定を保存したり、アプリケーションを立ち上げる時に使うポートを変更できたりします。

詳細は、[概要 > 設定 > local.jsファイル](https://sailsjs.com/documentation/concepts/configuration/the-local-js-file)を参照してください。

### アプリで`sails.config`にアクセスする

`config`オブジェクトはSailsアプリケーションインスタンス（`sails`）から使用できます。デフォルトでは、立ち上がっている最中は[グローバルスコープ](https://sailsjs.com/documentation/concepts/globals)として公開されているため、アプリケーションのどこからでも利用できます。

##### 例
```javascript
// This example checks that, if we are in production mode, csrf is enabled.
// It throws an error and crashes the app otherwise.
if (sails.config.environment === 'production' && !sails.config.security.csrf) {
  throw new Error('STOP IMMEDIATELY ! CSRF should always be enabled in a production deployment!');
}
```

### 環境変数を利用して、直接`sails.config`の値を設定する

設定ファイルを使うことに加えて、アプリケーションをコマンドラインから立ち上げる時に、設定キーの前に`sails_`をプリフィックスとして付け、ネストしたキー名は`__`（ダブルアンダースコア）で区切ることで、個々の設定の値をセットすることができます。この時すべての環境変数の値は、可能な限り、JSONとしてパースされます。例えば、[許可されたCORSオリジン](https://sailsjs.com/documentation/concepts/security/cors) （`sails.config.security.cors.allowOrigins`）をコマンドラインから`["http://somedomain.com","https://anotherdomain.com:1337"]`の値に設定するには次のようにします。

```javascript
sails_security__cors__allowOrigins='["http://somedomain.com","https://anotherdomain.com:1337"]' sails console
```

> JSONの中では、二重引用符を使うことで文字を示すことに注意してください。それから、単引用符使用して正しくコンソールからSailsへ値が渡されるようにしてください。

この値はSailsインスタンスの存続期間中のみ有効で、設定ファイル内の値はすべて上書きされます。

また、環境変数を使用して指定された設定は、[プログラムで起動される](https://sailsjs.com/documentation/concepts/programmatic-usage)インスタンスに自動的に適用されることはありません。

> いくつかの例外があります。`NODE_ENV`と`PORT`です。
> + `NODE_ENV`はNode.jsアプリケーションの規約です。`'production'`に設定されていた場合は、[`sails.config.environment`](https://sailsjs.com/documentation/reference/configuration/sails-config#?sailsconfigenvironment)にも同じく設定されます。
> + 同様に、`PORT`は[`sails.config.port`](https://sailsjs.com/documentation/reference/configuration/sails-config#?sailsconfigport)を設定するための別の手段です。これは厳密には利便性と後方互換性のためです。
>
> ここに両方の環境変数を同時に使用できる、よくある例を示します。
>
> ```bash
> PORT=443 NODE_ENV=production sails lift
> ```
>
> 現在のプロセスの環境に存在する`NODE_ENV`と`PORT`が、明示的に上書きされない限り、コマンドラインから起動するもしくはプログラムから起動するどちらのSailsアプリケーションにも適用されます。

環境変数はSailsアプリケーションを設定するための最も強力な方法の一つです。JSONシリアライズ可能である限り、どんな設定でもカスタマイズすることができるため、このアプローチは多くの問題を解決することができます。そして、本番環境デプロイに対して、我々コアチームがおすすめしている方法です。理由がいくつかあります。

+ 環境変数を使うことで、本番環境のデータベース資格情報やAPIトークンなどをチェックインする心配がなくなります。
+ これによって、Postgresqlホスト、Mailgunアカウント、S3認証情報、その他のメンテナンスを、速く、簡単に変更できます。さらに、コードを変更する必要もなく、チームの他の人からのダウンストリームコミットでのマージについても心配する必要はありません。
+ ホスティングの環境に応じて、UI（多くのPaaSで提供されているものです。例えば、[Heroku](http://heroku.com)や[Modulus](https://modulus.io)、[Azure Cloud](https://azure.microsoft.com/en-us/)も提供しています。）を通じて本番の設定を管理することが出来るでしょう。

### コマンドラインの引数を使用して、`sails.config`の値を設定する

コマンドラインで環境変数を設定することが現実的でない場合（Windowsシステムなど）には、通常のコマンドライン引数を使用して設定オプションを設定できます。これを行うには、2つのダッシュ（--）に続けてオプションの名前を指定します。ネストされたキー名はドットで区切ります。コマンドライン引数は、配列や辞書などのJSONを解析せず、特殊な構文を使用して文字列、数値、ブール値を処理する[minimist](https://github.com/substack/minimist/tree/0.0.10)によって解析されます。いくつかの例を示します。

```javascript
// Set the port to 1338
sails lift --port=1338

// Set a custom "email" value to "foo@bar.com":
sails lift --custom.email='foo@bar.com'

// Turn on CSRF support
sails lift --security.csrf

// Turn off CSRF support
sails lift --no-security.csrf

// This won't work; it'll just try to set the value to the string "[1,2,3]"
sails lift --custom.array='[1,2,3]'
```

### カスタム設定

Sailsの設定ローダーを活用して、独自のカスタム設定を管理することもできます。詳細については、[sails.config.custom](https://sailsjs.com/config/sails-config-custom)を参照してください。

### コマンドラインインターフェースの設定

設定に関しては、ほとんどの場合、アプリケーションの実行時設定（ポート、データベース設定など）を管理することに重点を置いています。ただし、Sails CLI自体をカスタマイズすることもできます。ワークフローを簡素化し、繰り返し作業を減らし、カスタムビルドの自動化などを実行できます。ありがたいことに、Sails v0.10はこれを行うための強力な新しいツールを追加しました。

[.sailsrcファイル](https://sailsjs.com/documentation/anatomy/.sailsrc)は、Sailsの他の設定ファイルに比べると変わっています。これは、Sails CLIの設定にも使用可能で、他にもシステム全体や、ディレクトリのグループ、そして特定のフォルダに`cd`したときにのみにも有効です。なぜ必要なのかというと、`sails generate`および`sails new`が実行されたときに使用される[ジェネレータ](https://sailsjs.com/documentation/concepts/extending-sails/Generators)をカスタマイズするためですが、独自のカスタムジェネレータをインストールしたり、ハードコードされた設定を上書きするというような用途でも有効です。

そしてSailsは「最も近い」`.sailsrc`を探すので、現在の作業ディレクトリの祖先ディレクトリに、クラウドでホストされたコードリポジトリにチェックインすることができない秘密の設定（例えばデータベースパスワードのようなもの）を行うために、このファイルを安全に使用することができます。"$HOME"ディレクトリに`.sailsrc`ファイルをおいてください。詳細については、[.sailsrcファイルに関するドキュメント](https://sailsjs.com/documentation/anatomy/.sailsrc)を参照してください。

### 設定の優先順位

`sails lift`もしくは`node app.js`、さらにはプログラムからの起動（[`sails.lift()`](https://sailsjs.com/documentation/reference/application/advanced-usage/sails-lift)、 [`sails.load()`](https://sailsjs.com/documentation/reference/application/advanced-usage/sails-load)）、それぞれの起動方法に応じて、Sailsはたくさんのソースコードから、特定の順番に設定を読み込みます。

##### `sails lift`もしくは`node app.js`から起動した場合の優先順位（高いものから順に）

+ [minimist](https://github.com/substack/minimist/tree/0.0.10)によってパースされたコマンドラインオプション。例えば`sails lift --custom.mailgun.apiToken='foo'`は`sails.config.custom.mailgun.apiToken`になります。
+ `sails_`が先頭につき、ドットを二重のアンダースコアで表現した、[環境変数](https://en.wikipedia.org/wiki/Environment_variable)。例えば、`sails_port=1492 sails lift`（[A few more examples](https://gist.github.com/mikermcneil/92769de1e6c10f0159f97d575e18c6cf)）。
+ アプリケーションのディレクトリか、`../`や`../../`などで最初に見つかった[`.sailsrc`ファイル](https://sailsjs.com/documentation/concepts/configuration/using-sailsrc-files)
+ ホームフォルダにある`.sailsrc`（例えば、`~/.sailsrc`）。
+ アプリケーションにある`config/local.js`ファイル。
+ アプリケーションの`config/env/*`にある、現在のNODE_ENVと名前が合致するファイル（デフォルトは`development`）。
+ アプリケーションの`config/`ディレクトリに存在する他のファイル（あれば）。

##### プログラムから起動した場合の優先順位（高いものから順に）

+ `.lift()`もしくは`.load()`に最初の引数として渡された、オプション上書き用のディクショナリ（`{}`）。
+ アプリケーションにある、`config/local.js`ファイル。
+ アプリケーションの`config/env/*`にある、現在のNODE_ENVと名前が合致するファイル（デフォルトは`development`）。
+ アプリケーションの`config/`ディレクトリに存在する他のファイル（あれば）。

### 注釈
> `sails.config`にある設定の意味は、場合によっては、"lift"プロセスの最中のみSailsによって解釈されます。つまり、実行中にオプションを変更しても効果はありません。たとえば、アプリケーションが実行されているポートを変更するには、`sails.config.port`を変更するだけで済みません。設定ファイルやコマンドライン引数などで設定を変更または上書きしてから、サーバを再起動する必要があります。


<docmeta name="displayName" value="設定">
<docmeta name="nextUpLink" value="/documentation/concepts/policies">
<docmeta name="nextUpName" value="Policies">
