# デプロイ

### デプロイする前に

Webアプリケーションを起動する前に、次のような自問をしてください。

+ 予想されるトラフィックは何ですか？
+ 契約上、サービスレベル契約（SLA）などの稼働時間保証を満たす必要がありますか？
+ どのような種類のユーザエージェントがあなたのインフラストラクチャに "ぶつかる"でしょうか？
  + デスクトップのウェブブラウザ
  + モバイルのウェブブラウザ（フォームファクタはなんでしょう？タブレットかハンドセットか、それともどっちも？）
  + スマートTVやコンソールゲーム機の、埋め込みブラウザ
  + Androi、iOS、ウィンドウズフォンなどのスマートフォンアプリ
  + PhoneGapやElectronなどのアプリ
  + 開発者（cURL、Postman、AJAXリクエスト、ウェブソケットを使用するフロントエンドのアプリ）
  + そのほかのデバイス（tvs、時計、トースター…？）
+ そして彼らはどんな種類のものを要求していますか？（HTML？JSON？XML？）
+ Socket.ioでリアルタイム機能を利用しますか？
  + チャット、リアルタイム解析、アプリ内通知/メッセージ
+ どのようにクラッシュやエラーを追跡していますか？
  + [Papertrail](https://papertrailapp.com/)のようなホスティングサービスと`sails.log()`を組み合わせて使用していますか？
+ ローカルで立ち上げようとしたとき、環境変数の`NODE_ENV`を、"production"に設定しましたか？
  + これをテストする簡単な方法は、`NODE_ENV=production node app`を実行することです（もしくは`sails lift --prod`）。

### 本番環境向けにアプリケーションを設定する

本番環境でのみ適用される構成は、[いくつかの方法](https://sailsjs.com/documentation/reference/configuration)で提供できます。ほとんどのアプリは、環境変数と`config/env/production.js`を組み合わせて使用​​しています。ただし、このセクションと[スケーリングのセクション](https://sailsjs.com/documentation/concepts/deployment/scaling)では、どのように作業を進めるにしても、実稼働に進む前に確認か変更をする必要がある設定について説明します。

### 1台のサーバーにデプロイする

Node.jsは相当早いです。多くのアプリでは、1台のサーバーで、少なくとも最初は予想されるトラフィックを処理できます。

> このセクションでは、単一サーバーのSailsデプロイメントを中心に説明します。この種のデプロイメントは、本質的に規模が限られています。Sails/Nodeアプリケーションをロードバランサの後ろに配置する方法については、[スケーリング](https://sailsjs.com/documentation/concepts/deployment/scaling)を参照してください。

多くのチームは、ロードバランサやプロキシの背後にプロダクションアプリを配備することにしています（例えば、HerokuやModulusのようなPaaSやnginxサーバの背後に）。これは、スケーラビリティの変更が必要な場合やサーバーを追加する必要がある場合に備え、アプリケーションの将来性を確保するのに役立つので、多くの場合適切なアプローチです。ロードバランサまたはプロキシを使用している場合、無視できる項目が以下に示すようにいくつかあります。

> SailsがSSL証明書を使用することについては心配しないでください。SSLはほとんどの場合、ロードバランサ/プロキシサーバまたはPaaSによって解決されます。
> nginxのようなプロキシの背後にいなければ、ポート80で実行するようにアプリケーションを設定することについて心配する必要はおそらくありません。ほとんどのPaaSプロバイダは自動的にポートを把握します。プロキシサーバーを使用している場合は、そのドキュメントを参照してください（あなたのSailsアプリケーションのポートを設定する必要があるかどうかは、設定​​方法によって異なります）。

> アプリケーションがソケットを使用していて、かつnginxを使用している場合は、websocketメッセージをサーバに中継するように設定してください。WebSocketのプロキシについてのガイダンスは、[nginxのドキュメント](http://nginx.org/en/docs/http/websocket.html)を参照してください。

##### 環境変数の`NODE_ENV`を、`'production'`に設定する

アプリケーションの環境設定を`'production'`に設定して、Sailsに本気の顔をさせます。つまり、あなたのアプリケーションは本番環境で実行されています。これは、最も重要なステップです。Sailsアプリケーションをデプロイする前に1つの設定を変更する時間があれば、これが設定される必要があります！

アプリケーションが本番環境で実行されている場合：
  + Sailsに組み込まれたミドルウェアやその他の依存関係は、より効率的なコードを使用するように切り替わります。
  + すべての[モデルの移行設定](https://sailsjs.com/documentation/concepts/models-and-orm/model-settings)は強制的に`migrate: 'safe'`に設定されます。これは、展開中に運用データを誤って破損しないようにするためのフェイルセーフです。
  + アセットパイプラインはプロダクションモードで実行されます（該当する場合）。つまり、Sailsアプリケーションは、すべてのスタイルシート、クライアントサイドスクリプト、プリコンパイルされたJSTテンプレートをミニファイルされた`.css`と`.js`ファイルにコンパイルして、ページの読み込み時間を短縮し、帯域幅の消費を減らすことができます。
  + エラーメッセージや`res.serverError()`からのスタックトレースは引き続きログとして記録されますが、レスポンスでは送信されません（これは、暗号化されたパスワードやSailsアプリケーションが存在するサーバーのファイルシステムのパスなど、機密情報にアクセスすることを防ぐためです。）

>**注意:**
>もし他の方法で[`sails.config.environment`](https://sailsjs.com/documentation/reference/configuration/sails-config#?sailsconfigenvironment)を`'production'`に設定するなら、それはすごく良いです。Sailsは自動的に`NODE_ENV`環境変数を`'production'`として設定します（または警告をログに記録しますので、コンソールに注意してください）。この環境変数が非常に重要な理由は、使用しているフレームワークに関係なく、Node.jsの普遍的な規約です。組み込みのミドルウェアとSailsの依存関係は、`NODE_ENV`が本番環境で設定されると想定しています。そうでなければ、開発用に設計された効率の低いコードパスを使用します。

##### `sails.config.sockets.onlyAllowOrigins`の値を設定する

アプリケーションでソケットが有効になっている場合（つまり、`sails-hook-sockets`モジュールがインストールされている場合）、セキュリティ上の理由から、Webソケット経由でアプリケーションに接続する必要のある配列の配列を`sails.config.sockets.onlyAllowOrigins`に設定する必要があります。アプリケーションの`config/env/production.js`ファイルで設定できます。詳細については、`onlyAllowOrigins`についての詳細な情報は、[ソケット設定のドキュメント](https://sailsjs.com/documentation/reference/configuration/sails-config-sockets)を参照してください。

##### ポート80で実行するようにアプリケーションを設定する

`sails_port`環境変数を使用するか、`--port`コマンドラインオプションを設定するか、プロダクション設定ファイルを変更するか、いずれにせよSails設定の最上位レベルに以下を追加します。

```javascript
port: 80
```

> このドキュメントの上部で言及しているように、アプリケーションがロードバランサもしくはプロキシの後ろで実行されている場合は、この手順を無視してください。

##### モデルに使用する、本番環境データベースを設定する

すべてのモデルでデフォルトのデータストアが使用されている場合、本番データベースの設定は、`sails.config.datastores.default`を[config/env/production.js](https://sailsjs.com/documentation/concepts/configuration#?environmentspecific-files-config-env)ファイルで正しく設定するだけです。

アプリケーションが複数のデータベースを使用している場合も、プロセスは似ています。アプリケーションで使用するすべてのデータストアについて、[config/env/production.js](https://sailsjs.com/documentation/concepts/configuration#?environmentspecific-files-config-env)ファイルにある`sails.config.datastores`の辞書に項目を追加します。

バージョンコントロール（gitなど）を使用している場合、データベースパスワードなどの機密情報は、アプリケーションの設定ファイルに含めてしまうと、リポジトリにチェックインされます。この問題の一般的な解決策は、環境変数として特定の機密設定を提供することです。詳細については、[設定](https://sailsjs.com/documentation/concepts/configuration)を参照してください。

MySQLなどのリレーショナルデータベースを使用している場合は、追加の手順があります。Sailsが本番環境でどのようにすべてのモデルに`migrate:safe`を設定するかを覚えていますか？つまり、アプリケーションを起動するときにオートマイグレーションは実行されません。ようするに、デフォルトではテーブルは存在しません。Sailsアプリケーションのリレーショナルデータベースの初回セットアップ時に処理する一般的な方法は次のとおりです。

  + 本番データベースサーバ上にデータベースを作成します（例`frenchfryparty`）
  + この本番データベースを使用するようにローカルのアプリケーションを設定しますが、環境変数を`'production'`として設定しないで、モデルの設定を`migrate: 'alter'`にしておきます。`sails lift`を一度だけ実行してください。ローカルサーバーの起動が完了したら、それを強制終了してください。
    + **注意！** 本番データベースにデータがない場合にのみこれを実行してください。

不安な場合や、本番データベースにリモートで接続できない場合は、上記の手順をスキップできます。代わりに、ローカルスキーマをダンプして本番データベースにインポートするだけです。

##### CSRF保護を有効にする

CSRFに対する保護は、Sailsアプリケーションにとって重要なセキュリティ手段です。CSRF保護を有効にして開発していない場合は（[`sails.config.security.csrf`](https://sailsjs.com/documentation/reference/configuration/sails-config-security#?sailsconfigsecuritycsrf)を見てください）、本番での運用に入る前に[CSRF保護を有効](https://sailsjs.com/documentation/concepts/security/csrf#?enabling-csrf-protection)にしてください。

##### SSLを有効にする

APIまたはWebサイトで認証が必要なものがあれば、本番環境ではSSLを使用すべきです。SailsアプリケーションでSSL証明書を使用するように設定するには、[`sails.config.ssl`](https://sailsjs.com/documentation/reference/configuration/sails-config)を使用します。

> 先ほども言及したように、アプリケーションがロードバランサまたはプロキシの背後で実行されている場合（たとえば、HerokuのようなPaaSの場合）は、この手順を無視してください。

##### アプリケーションを起動する

デプロイの最後のステップは、実際にサーバーを起動することです。例を示します。

```bash
NODE_ENV=production node app.js
```

また、コマンドラインオプションが好みでであれば、`--prod`を使えます。

```bash
node app.js --prod
# (Sails will set `NODE_ENV` automatically)
```

ご覧のように、本番環境では`sails lift`の代わりに、`node app.js`でSailsアプリケーションを起動すべきです。この方法だと、アプリケーションは`sails`コマンドラインツールにアクセスすることに依存しません。Sailsアプリケーションにバンドルされている`app.js`ファイルを実行するだけです（内容はまったく同じです）。

##### そして、起動し続ける

HerokuのようなPaaSにデプロイしていない場合を除いて、[`pm2`](http://pm2.keymetrics.io/)または[`forever`](https://github.com/foreverjs/forever)のようなツールを使用して、クラッシュした場合にアプリケーションサーバーがバックアップを開始するようにします。選択したデーモンに関係なく、そのようにサーバーを起動すべきでしょう。

### 次のステップ
+ [セキュリティ](https://sailsjs.com/documentation/concepts/security)
+ [ホスティングオプション](https://sailsjs.com/documentation/concepts/deployment/hosting)
+ [Sails/Node.jsアプリケーションのスケーリング](https://sailsjs.com/documentation/concepts/deployment/scaling)
+ [APIリファレンス](https://sailsjs.com/documentation/reference)


<docmeta name="displayName" value="デプロイ">
