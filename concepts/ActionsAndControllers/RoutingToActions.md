# アクションへのルーティング

### 手動ルーティング

デフォルトでは、[`config/routes.js`ファイル](https://sailsguides.jp/doc/reference/configuration/sails-config-routes)でコントローラーアクションをルートにバインドするまでユーザーはアクセスできません。ルートをバインドするときは、ユーザーがアクションにアクセスできるURLと、[CORSセキュリティ設定](https://sailsguides.jp/doc/concepts/security/cors#?configuring-cors-for-individual-routes)などのオプションを指定します。

`config/routes.js`ファイルでルートをアクションにバインドするために、HTTPメソッドとパス（**ルートアドレス**）をキーとして使用し、アクションを値として設定します（**ルートターゲット**）。

例えば、次の手動ルートを使用すると、`/make/a/sandwich`へのPOSTリクエストを受信するたびにアプリが`api/controllers/SandwichController.js`にある`make`アクションをトリガーします。

```js
  'POST /make/a/sandwich': 'SandwichController.make'
```

もしスタンドアロンアクションを使用している場合は、`api/controllers/sandwich/make.js`のファイルが存在するので、アクションから`api/controllers`への相対的なパスを使う、より直感的な構文が存在します。

```js
  'POST /make/a/sandwich': 'sandwich/make'
```

ルーティングの詳細については、[ルートのドキュメント](https://sailsguides.jp/doc/concepts/routes)を参照してください。

### 自動ルーティング

Sailsは`/:actionIdentity`への`GET`リクエストのルートを、自動でコントローラーアクションにバインドすることもできます。これはBlueprintアクションルーティングと呼ばれ、[`config/blueprints.js`](https://sailsguides.jp/doc/reference/configuration/sails-config-blueprints)ファイルの`actoins`を`true`に設定することで有効化できます。例えば、Blueprintアクションルーティングを有効化すると、`api/controllers/UserController.js`にある`signup`か`api/controllers/user/signup.js`のアクションは、`/user/signup`のルートにバインドされます。Sailsの自動ルートバインディングについては、[blueprintsドキュメント](https://sailsguides.jp/doc/reference/blueprint-api)を参照してください。

<docmeta name="displayName" value="Routing to actions">
<docmeta name="displayName_ja" value="アクションへのルーティング">
