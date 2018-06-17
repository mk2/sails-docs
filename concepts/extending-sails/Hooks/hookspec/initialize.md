# `.initialize(cb)`

`initialize`機能を使うと、非同期、または他のフックに依存するスタートアップタスクをフックで実行できます。すべてのSailsの設定は、フックの`initialize`機能が実行される前に完了することが保証されています。`initialize`に入れたいタスクの例を示します。

* リモートAPIへのログイン
* フックメソッドで使用するデータをデータベースから読み込む
* ユーザー設定ディレクトリからサポートファイルを読み込む
* 他のフックが最初に読み込まれるのを待つ

他のフックの機能のように、`initialize`はオプション機能であり、フックの定義に必ず書く必要はありません。実装する場合は、`initialize`は一つの引数を取ります。その引数はSailsが読み込みを終えるために呼び出される必要があるコールバック関数です。

```javascript
initialize: function(cb) {

   // Do some stuff here to initialize hook
   // And then call `cb` to continue
   return cb();

}
```

##### フックのタイムアウト設定

デフォルトでは、`initialize`関数は10秒以内に完了し、Sailsがエラーを投げる前に`cb`関数を呼ぶ必要があります。タイムアウトは、`_hookTimeout`キーにSailsが待つべき時間をミリ秒の値を設定することで指定することができます。これはフックの[`defaults`機能](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/defaults)で設定可能です。

```
defaults: {
   __configKey__: {
      _hookTimeout: 20000 // wait 20 seconds before timing out
   }
}
```

##### フックのイベントと依存関係

フックが正常に初期化されると、次の名前のイベントが発行されます。

`hook:<hook name>:loaded`

例を示します。

* コアの`orm`フックは`hook:orm:loaded`を初期化が完了した後に発行します。
* `node_modules/sails-hook-foo`にインストールされたフックは、`hook:foo:loaded`をデフォルトで発行します。
* 同じ`sails-hook-foo`フックでも、`sails.config.installedHooks['sails-hook-foo'].name`が`bar`に設定されている場合は、`hook:bar:loaded`が発行されます。
* `node_modules/mygreathook`にインストールされたフックは、`hook:mygreathook:loaded`を発行します。
* `api/hooks/mygreathook`にインストールされたフックは、`hook:mygreathook:loaded`を発行します。

あるフックが他のフックに依存させるために、「hook loaded」イベントを使用することができます。そのためには、`initialize`のロジックを`sails.on()`の呼び出しで包み込みます。例えば、フックが`orm`フックの読み込みを待ちたい場合は、`initialize`を次のようにします。

```javascript
initialize: function(cb) {

   sails.on('hook:orm:loaded', function() {

      // Finish initializing custom hook
      // Then call cb()
      return cb();

   });
}
```

いくつかのフックに依存させる場合は、イベント名を集めた配列を`sails.after`の呼び出し時に渡します。

```javascript
initialize: function(cb) {

   var eventsToWaitFor = ['hook:orm:loaded', 'hook:mygreathook:loaded'];
   sails.after(eventsToWaitFor, function() {

      // Finish initializing custom hook
      // Then call cb()
      return cb();

   });
}
```


<docmeta name="displayName" value=".initialize()">
<docmeta name="displayName_ja" value=".initialize()">
<docmeta name="stabilityIndex" value="3">
