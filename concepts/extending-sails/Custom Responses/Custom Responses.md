# カスタムレスポンス

### 概要

Sailsアプリケーションには、[アクションコード](https://sailsguides.jp/doc/concepts/actions-and-controllers)から呼び出すことのできる、予め設定されたいくつかのレスポンスが同梱されています。これらのデフォルトのレスポンスは"resource not found"（[`notfound`レスポンス](https://sailsguides.jp/doc/reference/res/res-not-found)）や"internal server error"（[`serverError`レスポンス](https://sailsguides.jp/doc/reference/res/res-server-error)）のような状況に対処することができます。もしアプリケーションがデフォルトのレスポンスの仕方を変更がする必要がある場合や、全く新しい応答を作成したい場合は、`api/responses`フォルダーにファイルを追加してください。

> 注意：`api/responses`はSailsアプリケーションを新しく生成した場合にデフォルトで作成されないため、レスポンスを追加・カスタマイズしたい場合は自分で追加する必要があります。

### レスポンスの使用

簡単な例として、次のアクションを考えてみましょう。

```javascript
getProfile: function(req, res) {

  // Look up the currently logged-in user's record from the database.
  User.findOne({ id: req.session.userId }).exec(function(err, user) {
    if (err) {
      res.status(500);
      return res.view('500', {data: err});
    }

    return res.json(user);
  });
}
```

このコードは、500エラーステータスを送信し、表示するビューにエラーデータを送信することによって、データベースエラーを処理します。しかし、このコードには主にいくつかの欠点があります。

* このレスポンスは **コンテンツネゴシエーション** ではありません。クライアントがJSON応答を期待している場合は、うまくいかないです。
* このレスポンスはエラーについて **あまりにも多くのことを明らかにしてしまいます**。本番環境では、エラーはターミナルに記録するのが最善でしょう。
* **標準化** されていません。上記の他の箇条書きにもかかわらず、このコードはこのアクションに固有のものであり、いろんな場所でエラー処理のために同じ形式を維持する努力をする必要があります。
**抽象化** されていません。他の場所で同様のアプローチを使用したい場合は、コードをコピー/ペーストする必要があります。

では、この置き換えを考えてみましょう。

```javascript
getProfile: function(req, res) {

  // Look up the currently logged-in user's record from the database.
  User.findOne({ id: req.session.userId }).exec(function(err, user) {
    if (err) { return res.serverError(err); }
    return res.json(user);
  });
}
```

このアプローチには多くの利点があります。

- より簡潔である
- エラーペイロードは標準化されている
- 本番環境と開発環境のロギングが考慮されている
- エラーコードが一貫している
- コンテンツネゴシエーション（JSONかHTML）が処理される
- APIの調整は、適切なレスポンスファイルへの簡単な編集で可能である

### レスポンスメソッドとファイル

`api/responses/`に保存したすべての`.js`ファイルは、`res.thatFileName()`で実行可能です。たとえば、`api/responses/insufficientFunds.js`は`res.insufficientFunds()`として実行することができます。


##### `req`や`res`、そして`sails`変数へのアクセス

リクエストとレスポンスのオブジェクトは、カスタムレスポンスの内部でも`this.req`や`this.res`として利用可能です。これにより、レスポンス関数は任意のパラメータを取ることができます。例を示します。

```javascript
return res.insufficientFunds(err, { happenedDuring: 'signup' });
```

カスタムレスポンスの実装は次のようになります。

```javascript
module.exports = function insufficientFunds(err, extraInfo){

  var req = this.req;
  var res = this.res;
  var sails = req._sails;

  var newError = new Error('Insufficient funds');
  newError.raw = err;
  _.extend(newError, extraInfo);

  sails.log.verbose('Sent "Insufficient funds" response.');

  return res.badRequest(newError);

}
```


### 組み込みのレスポンス

すべてのSailsアプリケーションには、あらかじめ設定されたレスポンスが組み込まれています。たとえば[`res.serverError()`](https://sailsguides.jp/doc/reference/res/res-server-error)や[`res.notFound()`](https://sailsguides.jp/doc/reference/res/res-not-found)などがあり、`api/responses`の配下に対応するファイルがなくても使用することができます。

デフォルトのレスポンスは、アプリケーションの`api/responses/`配下に同名のファイルを追加することで上書きすることができます（例えば、`api/responses/serverError.js`）。

> これを行うためのショートカットとして、[Sailsコマンドラインツール](https://sailsguides.jp/doc/reference/command-line-interface/sails-generate)を使うことも出来ます。
>
> 例を示します。
>
>```bash
>sails generate response serverError
>```
>


<docmeta name="displayName" value="Custom responses">
<docmeta name="displayName_ja" value="カスタムレスポンス">
