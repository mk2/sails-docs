# Sailsアプリケーションでフックを使う

## プロジェクトのフックを使う
プロジェクトのフックをアプリケーションで使用するには、まず`api/hooks`フォルダを無ければ作成します。そして、[プロジェクトのフックを作成するか](https://sailsguides.jp/doc/concepts/extending-sails/hooks/project-hooks)、`api/hooks`に使用したいフックのフォルダをコピーします。

## インストール可能なフックを使う
インストール可能なフックをアプリケーションで使うには、単にインストールしたいフックの名前と一緒に`npm install`を実行するだけです（たとえば`npm install sails-hook-autoreload`）。また、[作成したインストール可能なフックフォルダ](https://sailsguides.jp/doc/concepts/extending-sails/hooks/installable-hooks)をアプリケーションの`node_modules`フォルダに手作業でコピーもしくはリンクすることも可能です。

## フックメソッドの呼び出し
フックが公開するすべてのメソッドは、`sails.hooks.[<hook-name>]`オブジェクトから利用可能です。たとえば、`sails-hook-email`フックは`sails.hooks.email.send()`メソッドを提供しています（`sails-hook-`接頭辞は取り除かれます）。どのメソッドが提供されているかは、フックのドキュメントを参照してください。

## フックを設定する
アプリケーションにインストール可能なフックを追加したら、`config/local.js`や`config/env/development.js`のようないつものSails設定ファイルを使って設定することができます。また、自分自身で作成するカスタム設定ファイルも利用することができます。フックの設定は、通常、`sails-hook-`接頭辞が取り除かれたフック名の名前空間にあります。たとえば`sails-hook-email`の`from`設定は`sails.config.email.from`として利用可能です。インストール可能なフックのドキュメントでは、利用可能な設定オプションを説明する必要があります。

## インストール可能なフックを、Sailsがロードする方法を変更する
まれに、インストール可能なフックにSailsが使用する名前を変更するか、フックが使用する設定キーを変更することがあるかもしれません。インストール可能なフックと同じ名前のプロジェクトフックをすでに持っている場合や、すでにほかの設定キーを使用している場合にこのようなことになるでしょう。そのような競合を避けるために、Sailsは`sails.config.installedHooks.<hook-identity>`設定オプションを提供しています。フックのアイデンティティは、常にフックがインストールされているフォルダの名前になります。

```javascript
// config/installedHooks.js
module.exports.installedHooks = {
   "sails-hook-email": {
      // load the hook into sails.hooks.emailHook instead of sails.hooks.email
      "name": "emailHook",
      // configure the hook using sails.config.emailSettings instead of sails.config.email
      "configKey": "emailSettings"
   }
};
```

> 注意：`config/installedHooks.js`ファイルを自分自身で作る必要があるかもしれません。

* [フックの概要](https://sailsguides.jp/doc/concepts/extending-sails/hooks)
* [フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)
* [プロジェクトフックを作成する](https://sailsguides.jp/doc/concepts/extending-sails/hooks/project-hooks)
* [インストール可能なフックの作成](https://sailsguides.jp/doc/concepts/extending-sails/hooks/installable-hooks)



<docmeta name="displayName" value="Using hooks">
<docmeta name="displayName_ja" value="フックを使う">
<docmeta name="stabilityIndex" value="3">
