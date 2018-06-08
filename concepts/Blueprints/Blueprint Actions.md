# Blueprintアクション

Blueprintアクション（暗黙の[blueprint「アクション」_ルート_](https://sailsguides.jp/doc/concepts/blueprints/blueprint-routes#?action-routes)と混同しないでください）は、モデルとともに動作するように設計された一般的なアクションです。アプリケーションのデフォルトの動作であると考えてください。例えば、`User.js`モデルがあれば、`find`、`create`、`update`、`destroy`、`populate`、`add`および`remove`アクションについては記述することなく暗黙的に存在します。

デフォルトでは、blueprintの[RESTfulルート](https://sailsguides.jp/doc/concepts/blueprints/blueprint-routes#?restful-routes)と[ショートカットルート](https://sailsguides.jp/doc/concepts/blueprints/blueprint-routes#?shortcut-routes)は、それぞれの対応するblueprintのアクションにバインドされています。しかし、特定のコントローラーではそのファイルにカスタムアクションを作成すること（例として`ParrotController.find`）で、blueprintのアクションを上書きすることができます。


現在のバージョンのSailsには、次のblueprinntアクションが含まれています。

+ [find](https://sailsguides.jp/doc/reference/blueprint-api/find-where)
+ [findOne](https://sailsguides.jp/doc/reference/blueprint-api/find-one)
+ [create](https://sailsguides.jp/doc/reference/blueprint-api/create)
+ [update](https://sailsguides.jp/doc/reference/blueprint-api/update)
+ [destroy](https://sailsguides.jp/doc/reference/blueprint-api/destroy)
+ [populate](https://sailsguides.jp/doc/reference/blueprint-api/populate)
+ [add](https://sailsguides.jp/doc/reference/blueprint-api/add-to)
+ [remove](https://sailsguides.jp/doc/reference/blueprint-api/remove-from)
+ [replace](https://sailsguides.jp/doc/reference/blueprint-api/replace)

### ソケット通知

ほとんどのblueprintアクションには、アプリがWebsocketを有効化している場合に使用可能になる機能を持っています。例えば、blueprintの**find**アクションがソケットクライアントからリクエストを受け取ると、そのソケットは将来の通知のために[subscribe](https://sailsguides.jp/doc/reference/web-sockets/resourceful-pub-sub/subscribe)を行います。それから、**update**のようなblueprintアクションを使って任意のタイミングでレコードが変更されたとき、Sailsは特定の通知を[publish](https://sailsguides.jp/doc/reference/web-sockets/resourceful-pub-sub/publish)します。

個々のblueprintアクションの動作を理解する最も良い方法は、[リファレンスページ](https://sailsguides.jp/doc/reference/blueprint-api)（または上記のリスト）を読むことです。しかしSailsのblueprint APIでリアルタイム機能がどのように動作するかの全体像を知りたい場合は、[**Concepts > Realtime**](https://sailsguides.jp/doc/concepts/realtime)を参照してください。（詳細が古くても問題ない場合は、[2013年の「Intro to Sails.js」の動画](https://www.youtube.com/watch?v=GK-tFvpIR7c)をチェックしてください。）

> Sailsのblueprintアクションがpublishするすべての通知に対する、より進んだ詳細については、次を参照してください。
> + [Chart A (scenarios vs. notification types)](https://docs.google.com/spreadsheets/d/10FV9plyHR4gE9xIomIZlF-YS1S54oHEdvH8ZmTC1Fnc/edit#gid=0)
> + [Chart B (actions vs. recipients)](https://docs.google.com/spreadsheets/d/1B6i8aOoLNLtxJ4aeiA8GQ2lUQSvLOrP89RSLr7IAImw/edit#gid=0)

### blueprintアクションを上書きする

同名の[カスタムアクション](https://sailsguides.jp/doc/concepts/actions-and-controllers)を定義することで、任意のblueprintアクションを上書きすることもできます。

```javascript
// api/controllers/user/UserController.js
module.exports = {

  /**
   * A custom action that overrides the built-in "findOne" blueprint action.
   * As a dummy example of customization, imagine we were working on something in our app
   * that demanded we tweak the format of the response data, and that we only populate two
   * associations: "company" and "friends".
   */
  findOne: function (req, res) {

    sails.log.debug('Running custom `findOne` action.  (Will look up user #'+req.param(\'id\')...');

    User.findOne({ id: req.param('id') }).omit(['password'])
    .populate('company', { select: ['profileImageUrl'] })
    .populate('top8', { omit: ['password'] })
    .exec(function(err, userRecord) {
      if (err) {
        switch (err.name) {
          case 'UsageError': return res.badRequest(err);
          default: return res.serverError(err);
        }
      }

      if (!userRecord) { return res.notFound(); }

      if (req.isSocket) {
        User.subscribe(req, [user.id]);
      }

      return res.ok({
        model: 'user',
        luckyCoolNumber: Math.ceil(10*Math.random()),
        record: userRecord
      });
    });
  }

}
```

> [actions2](https://sailsguides.jp/doc/concepts/actions-and-controllers#?actions-2)を使用し、スタンドアロンアクションを`api/controllers/user/find-one.js`として作成することでも、同じことを行うことができます。

<docmeta name="displayName" value="Blueprint actions">
<docmeta name="displayName_ja" value="Blueprintアクション">
