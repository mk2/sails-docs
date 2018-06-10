# フックの仕様

### 概要
各Sailsフックは、実行中の`sails`インスタンスへの参照である1つの引数を受け取るようなJavascriptの関数として実装され、このドキュメントで後述する1つ以上のキーを持つオブジェクトを返します。そのため、最も基本的なフックは次のようになります。

```javascript
module.exports = function myBasicHook(sails) {
   return {};
}
```

たいしたことはしませんが、動くでしょう！

それぞれのフックは、それ自身のフォルダに`index.js`として保存される必要があります。フォルダ名はフックを一意に識別し、フォルダには任意の数の追加ファイルとサブフォルダを含めることができます。先ほど示した例を拡張するには、Sailsプロジェクトの`api/hooks/my-basic-hook`フォルダに`index.js`として先ほどの内容を保存し、`sails lift --verbose`を実行してアプリケーションを起動します。すると出力に次のように表示されます。

`verbose: my-basic-hook hook loaded successfully.`

### フックの機能
以下の機能をフックに実装することができます。すべての機能は実装してもしなくてもよく、フック関数が返すオブジェクトに追加することで実装できます。

* [.defaults](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/defaults)
* [.configure()](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/configure)
* [.initialize()](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/initialize)
* [.routes](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/routes)
* [.registerActions()](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/register-actions)

### カスタムフックのデータと関数
メインのフック関数から返すオブジェクトに追加された他のキーは、`sails.hooks.[<hook name>]`オブジェクトに提供されます。これはエンドユーザーがフックの機能をカスタムする方法です。フックで非公開にしたいデータや関数は、返すオブジェクトの外に追加することができます。

```javascript
// File api/hooks/myhook/index.js
module.exports = function (sails) {

   // This var will be private
   var foo = 'bar';

   return {

     // This var will be public
     abc: 123,

     // This function will be public
     sayHi: function (name) {
       console.log(greet(name));
     }

   };

   // This function will be private
   function greet (name) {
      return 'Hi, ' + name + '!';
   }

};
```

上記の公開されている変数と関数は、`sails.hooks.myhook.abc`と`sails.hooks.myhook.sayHi`としてそれぞれ利用可能です。


<docmeta name="displayName" value="Hook specification">
<docmeta name="displayName_ja" value="フックの仕様">
<docmeta name="stabilityIndex" value="3">
