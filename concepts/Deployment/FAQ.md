# よくある質問


### 環境変数を使えますか？

はい！任意のNodeアプリケーションと同様に、環境変数は`process.env`から使用できます。

Sailsには、`sails.config`に直接公開される独自のカスタム設定を作成するための、組み込みのサポートも付属しています。また、カスタムもしくは組み込みのいずれであっても、環境変数を使用して、`sails.config`のすべての設定プロパティを上書きできます。詳細については、[設定](https://sailsguides.jp/doc/concepts/configuration)のドキュメントを参照してください。

### 本番データベースの認証情報はどこに置くのですか？その他の設定は？

Sailsアプリケーションに設定を追加する最も簡単な方法は、`config/`にあるファイルを変更するか、新しいファイルを追加することです。Sailsは環境固有の設定をサポートしているので、`config/env/production.js`のようなファイルを使用することができます。繰り返しますが、詳細については、[設定](https://sailsguides.jp/doc/concepts/configuration)のドキュメントを参照してください。

しかし、ある特定の設定情報をリポジトリにチェックインしたくない場合もあります。**この手の設定を行うべき場所は、環境変数です。**

とはいえ、環境変数を使用した開発（ラップトップなど）では、時には厄介なことがあります。他のデプロイ/マシン固有の設定にとっては、つまり非公開にしたい様々な認証情報については、`config/local.js`ファイルを使用することもできます。このファイルは、デフォルトで`.gitignore`ファイルに含まれています。これにより、うっかり認証情報をコードリポジトリにコミットすることを防ぎます。

**config/local.js**
```javascript
// Local configuration
//
// Included in the .gitignore by default,
// this is where you include configuration overrides for your local system
// or for a production deployment.
//
// For example, to use port 80 on the local machine, override the `port` config
module.exports = {
    port: 80,
    environment: 'production',
    adapters: {
        mysql: {
            user: 'root',
            password: '12345'
        }
    }
}
```



### サーバーへSailsアプリケーションを配置するにはどうすればよいですか？

HerokuやModulusのようなPaasを使用している場合、簡単です。Paasの指示に従ってください。

それ以外の場合は、サーバーのIPアドレスを取得し、`ssh`でサーバーに入ってください。次に、NPMから`npm install -g sails`と`npm install -g forever`を実行し、Sailsと`forever`をグローバルにインストールします。最後にプロジェクトを`git clone`でサーバー上の新しいフォルダに入れてから（gitリポジトリがない倍は、`scp`でサーバーに入れます）、`forever start app.js`を実行します。


### パフォーマンスに関しては、何を想定すべきですか？

Sailsのパフォーマンスのベースラインは、標準のNode.js/Expressアプリケーションから期待されるパフォーマンスに匹敵します。言い換えれば、速いのです！私たちはSailsのコアでいくつかの最適化を行ってきましたが、重要視しているのは、依存関係をなくしてめちゃくちゃにすることではありません。簡単なベンチマークについては、[http: //serdardogruyol.com/sails-vs-rails-a-quick-and-dirty-benchmark](http: //serdardogruyol.com/sails-vs-rails-a-quick-and-dirty-benchmark)を参照してください。

本番のSailsアプリケーションで最も一般的なパフォーマンスボトルネックは、データベースです。アプリケーションが存続するうちにユーザーが増えていくので、テーブル/コレクションに適切なインデックスを設定し、ページ単位の結果を返すクエリを使用することがますます重要になります。最終的に本番データベースが膨大になり、数千万のレコードが格納されるようになると、スロークエリの検索と最適化を手作業で開始するでしょう（または[`.query()`](https://sailsguides.jp/doc/reference/waterline-orm/models/query)か[`.native()`](https://sailsguides.jp/doc/reference/waterline-orm/models/native)を呼び出すか、もしくはより低レイヤーなデータベースドライバを使うかも）。


### コネクトセッションメモリストアに関する警告は何ですか？

Sailsアプリケーションでセッションを使用している場合は、本番環境では組み込みのメモリストアを使用しないでください。このメモリセッションストアは、複数のサーバーでスケールしない開発専用のツールです。1台のサーバしかないとしても、パフォーマンスはあまり良いものではありません（[#3099](https://github.com/balderdashy/sails/issues/3099)と[#2779](https://github.com/balderdashy/sails/issues/2779)を参照してください）。

本番でのセッションストアの設定手順については、[sails.config.session](https://sailsguides.jp/doc/reference/configuration/sails-config-session)を参照してください。セッションのサポートを完全に無効にする場合は、アプリの`.sailsrc`ファイルの`session`フックをオフにします。

```javascript
"hooks": {
  "session": false
}
```


<docmeta name="displayName" value="よくある質問">
