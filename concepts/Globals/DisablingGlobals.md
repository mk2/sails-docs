# グローバル変数の無効化

Sailsがどの変数を公開するかは、[`sails.config.globals`](https://sailsguides.jp/doc/reference/configuration/sails-config-globals)によって決まります。通常は[`config/globals.js`](https://sailsguides.jp/doc/anatomy/config/globals-js)に設定されています。

すべてのグローバル変数を無効化するには、`false`を設定します。

```js
// config/globals.js
module.exports.globals = false;
```

いくつかのグローバル変数を無効化したい場合は、代わりにオブジェクトをしています。例を示しましょう。

```js
// config/globals.js
module.exports.globals = {
  _: false,
  async: false,
  models: false,
  services: false
};
```

### 注意点

> + 覚えておいてほしいこととして、`sails`を含むグローバル変数は、いずれもsailsが起動した後にアクセス可能になります。つまり、`sails.models.user`や`User`を関数の外で使うことはできません（`sails`の読み込みが完了していないため）。

<!-- not true anymore:
Most of this section of the docs focuses on the methods and properties of `sails`, the singleton object representing your app.
-->

<docmeta name="displayName" value="Disabling globals">
<docmeta name="displayName_ja" value="グローバル変数の無効化">
