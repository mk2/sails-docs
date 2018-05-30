# スケーリング

アプリケーションに多くのトラフィックがあることがすぐに分かっている場合（またはトラフィックが既にある場合）、スケーラブルなアーキテクチャを設定して、アプリケーションに来るリクエストが増えるにつれてサーバーを追加することができます。


### パフォーマンス

本番環境では、SailsはConnect、Express、Socket.ioのように動作します（[例](http://serdardogruyol.com/?p=111)）。あなたが共有したいベンチマークを持っているなら、ブログの投稿や記事を書いて[@sailsjs](http://twitter.com/sailsjs)をつけてください。しかし、ベンチマークはさておき、ほとんどのパフォーマンスとスケーラビリティのメトリックはアプリケーション固有であることに注意してください。アプリケーションの実際のパフォーマンスは、使用している基盤となるフレームワークよりも、ビジネスロジックとモデル呼び出しをどのように実装するかに、より関係しています。


### アーキテクチャの例

```
                             ....
                    /  Sails.js server  \      /  Database (e.g. Mongo, Postgres, etc)
Load Balancer  <-->    Sails.js server    <-->    Socket.io message queue (Redis)
                    \  Sails.js server  /      \  Session store (Redis, Mongo, etc.)
                             ....
```


### クラスタ化されたデプロイのために、アプリケーションを用意する

Node.js（Sails.jsも）のアプリケーションは水平方向にスケーリングします。パワフルで効率的なアプローチですが、これには多少の計画が必要です。スケーリングという観点では、アプリケーションを複数のSails.jsサーバにコピーして、ロードバランサの背後に投げたいと思うでしょう。

このアプリケーションをスケーリングする大きな課題の1つは、これらのクラスタ化されたデプロイメントは、物理的に異なるマシン上にあるため、メモリを共有できないことです。さらに、ロードバランサは、利用可能なリソースが最も多いSailsサーバーに各リクエストをルーティングするため、ユーザーがリクエスト同士（HTTPまたはソケットのいずれか）を同じサーバーに「固定」する保証はありません。サーバーサイドアプリケーションのスケーリングについて覚えておくべき最も重要なことは、ステートレスでなければならないということです。つまり、同じコードをn台の違うサーバーにデプロイできなければいけないということです。あるサーバーに来たリクエストは、ほかのすべてのサーバーで同じように処理できなければいけないということです。幸いなことに、Sailsアプリケーションは、こういったデプロイの準備が何もすることなくすぐにできるようになっています。しかし、複数のサーバーにアプリをデプロイする前に、いくつかのことをする必要があります。

+ アプリケーションで使用している他の依存関係が、共有メモリに依存していないことを確認してください。
+ モデルで使用しているデータベース（MySQL、Postgres、Mongoなど）がスケーラブルであることを確認してください（例：シャーディング/クラスタ）
+ **アプリでセッションを使用している場合：**
  + Redisなどの共有セッションストアを使用するようにアプリケーションを設定し（単に`config/session.js`内の`adapter`オプションのコメントを外します）、"@sailshq/connect-redis"セッションアダプターをアプリケーションの依存ライブラリとしてインストールします（例：`npm install @sailshq/connect-redis --save`）。本番用のセッションストアの設定の詳細については、[sails.config.sessionドキュメント](https://sailsjs.com/documentation/reference/configuration/sails-config-session#?production-config)を参照してください。
+ **アプリがソケットを使用する場合：**
  + socket.ioメッセージを配信するための共有メッセージキューとしてRedisを使用するようにアプリケーションを設定します。Socket.io（Sails.jsも）のアプリケーションはデフォルトでソケット用のRedisをサポートしているので、リモートのredis pubsubサーバを有効にするには、`config/env/production.js`の該当する行のコメントを外します。
  + "@sailshq/socket.io-redis"アダプターをアプリケーションの依存ライブラリとしてインストールします（例：`npm install @sailshq/socket.io-redis`）。
+ **クラスタが単一のサーバー上にある場合（たとえば、[pm2クラスタモード](http://pm2.keymetrics.io/docs/usage/cluster-mode/)を使用）**
  + Gruntタスクによるファイルの競合の問題を回避するには、常に`production`環境でアプリケーションを起動したり、[Gruntを完全にオフにすること](https://sailsjs.com/documentation/concepts/assets/disabling-grunt)を検討してください。シングルサーバクラスタにおけるGruntの問題の詳細は、[こちら](https://github.com/balderdashy/sails/issues/3577#issuecomment-184786535)を参照してください。
  + ブートストラップが複数回実行されたとき（クラスタ内のノードごとに1回）に競合が発生しないように、データをデータベースに永続するためには、[`config/bootstrap.js`](https://sailsjs.com/documentation/reference/configuration/sails-config-bootstrap)に注意してください。

### PaaSにNode/Sailsアプリケーションをデプロイする

HerokuやModulusのようなPaaSにアプリケーションをデプロイするのは簡単です。状況によっては、細部にいくつかの悪魔が残っているかもしれませんが、ホスティングプロバイダのNodeサポートはここ数年で本当に良くなってきました。より多くのプラットフォーム固有の情報については、[ホスティング](https://sailsjs.com/documentation/concepts/deployment/Hosting)を見てください。

### 独自にクラスタをデプロイする

+ [ロードバランサ](https://ja.wikipedia.org/wiki/%E3%82%B5%E3%83%BC%E3%83%90%E3%83%AD%E3%83%BC%E3%83%89%E3%83%90%E3%83%A9%E3%83%B3%E3%82%B9)の背後にある複数のインスタンス（アプリケーションのコピーを実行しているサーバ）をデプロイする（例：nginx）
  + SSLリクエストを終端させるようにロードバランサを構成する
  + ただし、SailsにSSL設定を適用する必要はありません。Sailsに到達するまでにトラフィックはすでに復号化されています。
  + `forever`または`pm2`のようなデーモンを使用して各インスタンスでアプリケーションを立ち上げます（デモの詳細については、[https://sailsjs.com/documentation/concepts/deployment](https://sailsjs.com/documentation/concepts/deployment)を参照してください）。

### 最適化

Node/Sailsアプリケーションのエンドポイントの最適化は、他のサーバーサイドアプリケーションのエンドポイントの最適化とまったく同じです。たとえば、遅いクエリを特定して手動で最適化したり、クエリの数を減らしたりするなどです。Nodeアプリケーションの場合、CPUを浪費しているトラフィックが多いエンドポイントがある場合は、同期的な（つまりブロッキングしている）モデルのメソッド、サービス、またはmachineが、ループや再帰的な呼び出しで繰り返し呼び出されているかもしれません。

でも覚えておいて欲しいことがあります。

> 早すぎる最適化は諸悪の根源である -[ドナルド・クヌース](http://c2.com/cgi/wiki?PrematureOptimization)

どのツールを使用していても、質の高い文書化された読みやすいコードを書くことに集中して時間を費やすことが重要です。そうすれば、アプリケーションでコードパスを最適化することを余儀なくされた場合、そうするのがずっと簡単になるでしょう。


### ノート

> + セッションにRedisを使用する必要はありません。実際には、ConnectまたはExpress互換のセッションストアを使用できます。詳細については、[sails.config.session](sailsjs.com/documentation/reference/configuration/sails-config-session)を参照してください。
> + 一部のホストされたRedisプロバイダ（<a href="https://elements.heroku.com/addons/redistogo" target="_blank">Redis To Go</a>など）は、<a href="https://redis.io/topics/clients#client-timeouts">アイドル状態の接続に対してタイムアウトを設定</a>します。ほとんどの場合、アプリの予期しない動作を避けるため、この機能をオフにします。タイムアウトを無効にする方法の詳細は、プロバイダによって異なります（サポートチームに連絡する必要があります）。

<docmeta name="displayName" value="スケーリング">
