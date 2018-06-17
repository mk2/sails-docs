# `.routes`

`routes`機能によって、カスタムフックをロードした時に新しいルートをSailsアプリに簡単にバインドすることができます。実装する場合は、`routes`は`before`キーか`after`キー（もしくは両方）を持つオブジェクトである必要があります。それらのキーの値は、キーが[ルートアドレス](https://sailsguides.jp/doc/concepts/routes/custom-routes#?route-address)となり、値がルート処理用の`(req, res, next)`の標準的なパラメータを受け取るような関数となるような、オブジェクトとなる必要があります。`before`オブジェクトで指定されたすべてのルートは、ユーザールート（詳細は[sails.config.routes](https://sailsguides.jp/doc/reference/configuration/sails-config-routes)）と[blueprintルート](https://sailsguides.jp/doc/reference/blueprint-api#?restful-shortcut-routes-and-actions)の前にバインドされます。対して、`after`オブジェクトで指定されたルートは、カスタムルートとblueprintのルートの後にバインドされます。例えば、次に示す`count-requests`フックを考えてみます。

```javascript
module.exports = function (sails) {

  // Declare a var that will act as a reference to this hook.
  var hook;

  return {

    initialize: function(cb) {
      // Assign this hook object to the `hook` var.
      // This allows us to add/modify values that users of the hook can retrieve.
      hook = this;
      // Initialize a couple of values on the hook.
      hook.numRequestsSeen = 0;
      hook.numUnhandledRequestsSeen = 0;
      // Signal that initialization of this hook is complete
      // by calling the callback.
      return cb();
    },

    routes: {
      before: {
        'GET /*': function (req, res, next) {
          hook.numRequestsSeen++;
          return next();
        }
      },
      after: {
        'GET /*': function (req, res, next) {
          hook.numUnhandledRequestsSeen++;
          return next();
        }
      }
    }
  };
};
```

このフックは`before`オブジェクトで設定されている関数をすべてのリクエストに対して適用し、その`numRequestsSeen`変数をインクリメントします。また、`after`オブジェクトで設定されている関数を使ってすべての未処理のリクエスト（つまりアプリケーションでカスタムルートやblueprintが設定されていないすべてのルートへ来たもの）を処理します。

> フックで設定した2つの変数は、Sailsアプリケーションの他のモジュールで`sails.hooks["count-requests"].numRequestsSeen`と`sails.hooks["count-requests"].numUnhandledRequestsSeen`としてアクセスできます。


<docmeta name="displayName" value=".routes">
<docmeta name="displayName_ja" value=".routes">
<docmeta name="stabilityIndex" value="3">
