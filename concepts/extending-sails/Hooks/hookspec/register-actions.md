# `.registerActions()`

もしフックが新しいアクションをアプリケーションに追加し、そのアクションが[`sails.reloadActions()`](https://sailsguides.jp/doc/reference/application/sails-reload-actions)の呼び出し後も維持されて欲しい場合は、アクションを`registerActions`メソッド内で登録すべきです。

例えば、コアのSailsセキュリティフックは[`grant-csrf-token`アクション](https://sailsguides.jp/doc/concepts/security/csrf#?using-ajax-websockets)を`registerActions()`メソッド内から登録しています。

`registerActions`は、一つのコールバック（フックがアクションを追加した後に呼ぶもの）を引数として受け取る関数として実装する必要があります。コードの重複を避けるため、フックの[`initialize()`メソッド]((https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/initialize)からこのメソッドを呼び出したいかもしれません。

```
registerActions: function(cb) {

  // Register an action as `myhook/greet` that an app can bind to any route they like.
  sails.registerAction(function greet(req, res) {
    var name = req.param('name') || 'stranger';
    return res.status(200).send('Hey there, ' + name + '!');
  }, 'myhook/greet');

  return cb();

}
```

<docmeta name="displayName" value=".registerActions()">
<docmeta name="displayName_ja" value=".registerActions()">
<docmeta name="stabilityIndex" value="3">
