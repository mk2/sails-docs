# Blueprintルート

blueprintsを有効化して`sails lift`を実行すると、フレームワークは[特定のルートを自動的にバインド](https://sailsguides.jp/doc/concepts/Routes)するために、モデルと設定を検査します。これら暗黙のblueprintルート（「シャドールート」もしくは単に「シャドウ」と呼ばれることもあります）は、アプリが`config/routes.js`ファイル内でルートを手動でバインドしてなくても、特定のリクエストに応答することを可能にしています。有効にすると、blueprintルートは対応するblueprint*アクション*（下記の「アクションルート」を参照）を指すようになります。そのいずれも、カスタムコードで上書きすることができます。

Sailsには4種類のblueprintルートがあります。

### RESTfulなblueprintルート

RESTなblueprintsは、Sailsが従来のモデル用REST APIを公開するために自動で生成されるルートで、`find`や`create`、`update`そして`destroy`のアクションが含まれています。RESTfulルートのためのパスは、常に`/:modelIdentity`もしくは`/:modelIdentity/:id`になります。これらのルートは、HTTPメソッドによってどのアクションが実行されるかが決まります。

たとえば、[`rest`](https://sailsguides.jp/doc/reference/configuration/sails-config-blueprints#?routerelated-settings)を有効にすると、アプリの`Boat`モデルは次のルートを生成します。

+ **GET /boat** -> [`find` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/find-where)を使用して、クエリ文字列に指定された条件に一致するBoatを検索します。
+ **GET /boat/:id** -> [`findOne` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/find-one)を使用して、与えられrた一意のID値（すなわち主キー）を持つ単一のBoatを見つけます。
+ **POST /boat** -> [`create` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/create)を使用して、リクエストボディにある属性を使って新しいBoatを作成します。
+ **PATCH /boat/:id** -> [`update` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/update)を使用して、リクエストボディで指定された固有のIDと属性で、Boatを更新します。
+ **DELETE /boat/:id** -> [`destroy` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/destroy)を使用して、与えられた固有のIDを持つBoatを削除します。


もし`Boat`が`drivers`属性を通じで対多関係を`Driver`モデルに対して持っていた場合、次の追加ルートが使用できるようになります。

+ **PUT /boat/:id/drivers/:fk** -> [`add` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/add-to)を使用して、、`:fk`と同じIDを持つDriverを、`:id`と同じIDを持つBoatの`drivers`コレクションに追加します。
+ **DELETE /boat/:id/drivers/:fk** -> [`remove` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/remove-from)を使用して、`:fk`と同じIDを持つDriverを、`:id`と同じIDを持つBoatの`drivers`コレクションから削除します。
+ **PUT /boat/:id/drivers** -> [`replace` blueprint](https://sailsguides.jp/doc/reference/blueprint-api/replace)を使用して、リクエストボディに含まれる配列とそのIDを使用して、`drivers`コレクションをすべて置き換えます。

`rest` blueprintとはデフォルトで有効化されていて、不正なアクセスを防止する[ポリシー](https://sailsguides.jp/doc/concepts/Policies)によって保護されている限り、本番シナリオでの使用に適しています。

> 事前に注意してほしいこととして、ほとんどのウェブアプリやマイクロサービス、さらにはREST APIでも、単なる「作成」、「更新」、「破棄」といった機能は最終的には必要なくなります。時が来たら、あなた自身のカスタムアクションを書くことを恐れないでください。カスタムアクションとルートは、多くの場合そうできなければいけないように、RESTful APIとして機能し、必要に応じてblueprintと混在させ融合させることが出来るようできます。何よりも、[Node.jsでasync/awaitが導入された](https://gist.github.com/mikermcneil/c1028d000cc0cc8bce995a2a82b29245)ため、カスタムアクションを記述するためにコールバックを使用する必要がなくなりました。

<!--
If we keep this, we should find a way to word it better:
In fact, unless you're already familiar with how to customize blueprints in Sails, it's usually a good idea to lean towards using custom actions any time you find yourself unsure whether to continue with REST blueprints or switch to a custom action for a particular feature, it's usually a good idea to lean towards custom actions.
-->

##### 注釈

> + CSRF保護が有効になっている場合、POST/PUT/DELETEアクションに対して[CSRFトークン](https://sailsguides.jp/doc/concepts/security/csrf)を提供するか、無効にする必要があります。そうしないと、403レスポンスが返ります。
> + アプリにモデルの名前と一致する名前のコントローラが含まれている場合、独自のコントローラアクションを提供することによって、RESTfulルートが指すデフォルトアクションを上書きすることができます。たとえばがカスタム`find`アクションを含む`api/controllers/BoatController.js`というコントローラファイルがある場合、`GET /boat`ルートはそのアクションを指します。
> + 通常どおりコントローラーを使用しているかスタンドアロンアクションを使用しているかにかかわらず、同じロジックが適用されます。（Sailsに関する限り、`sails lift`によってアプリケーションがメモリにロードされて正常化されると、どこから来ても、すべてのアクションは同じように見えます）。
> + `config/routes.js`に上記のRESTfulルートのいずれかと一致するルートがアプリに含まれている場合は、そのルートがデフォルトルートの代わりに使用されます。

### ショートカットblueprintルート

ショートカットルートは、ブラウザのURLバーからモデルへのアクセスを提供する簡単な（開発モードのみの）ハックです。

ショートカットルートは次のとおりです。

| ルート | Blueprintアクション | URL例 |
| ----- | ----------------------- | ------- |
| GET /:modelIdentity/find | [find](https://sailsguides.jp/doc/reference/blueprint-api/find-where) | `http://localhost:1337/user/find?name=bob`
| GET /:modelIdentity/find/:id | [findOne](https://sailsguides.jp/doc/reference/blueprint-api/find-one) | `http://localhost:1337/user/find/123`
| GET /:modelIdentity/create | [create](https://sailsguides.jp/doc/reference/blueprint-api/create) | `http://localhost:1337/user/create?name=bob&age=18`
| GET /:modelIdentity/update/:id | [update](https://sailsguides.jp/doc/reference/blueprint-api/update) | `http://localhost:1337/user/update/123?name=joe`
| GET /:modelIdentity/destroy/:id | [destroy](https://sailsguides.jp/doc/reference/blueprint-api/destroy) | `http://localhost:1337/user/destroy/123`
| GET /:modelIdentity/:id/:association/add/:fk | [add](https://sailsguides.jp/doc/reference/blueprint-api/add-to) | `http://localhost:1337/user/123/pets/add/3`
| GET /:modelIdentity/:id/:association/remove/:fk | [remove](https://sailsguides.jp/doc/reference/blueprint-api/remove-from) | `http://localhost:1337/user/123/pets/remove/3`
| GET /:modelIdentity/:id/:association/replace?association=[1,2...] | [replace](https://sailsguides.jp/doc/reference/blueprint-api/replace) | `http://localhost:1337/user/123/pets/replace?pets=[3,4]`

**本番環境でSailsをliftするときは、ショートカットルートを無効にする必要があります。しかし開発時において、[ターミナル](https://sailsguides.jp/doc/reference/command-line-interface/sails-console)を使用したくない場合非常に便利です。**

##### 注釈

> + RESTfulルートと同様に、ショートカットルートは、一致するコントローラでアクションを提供するか、`config/routes.js`でルートを提供することでオーバーライドできます。
> + 同じRESTful/ショートカットルートに対しても、同じアクションが実行されます。例えば、`api/models/User.js`がロードされたときにSailsが作成する`POST /user`および`GET /user/create`は、同じコードを実行してレスポンスします。（もし[blueprintアクションを上書きしても](https://sailsguides.jp/doc/reference/blueprint-api#?overriding-blueprints)、そのようになります）。
> + <a href="https://en.wikipedia.org/wiki/NoSQL" target="_blank">NoSQL</a>データベース（<a href="https://docs.mongodb.com/" target="_blank">MongoDB</a>など）を使用しているモデルの[`schema`設定](https://sailsguides.jp/doc/concepts/models-and-orm/model-settings#?schema)を`false`に設定すると、ショートカットルートは未知の属性のパラメータ値を文字列として解釈します。もし`number`型で`players`属性がない場合は、`http://localhost:1337/game/create?players=2`というURLには注意してください。

### アクションシャドウルート

アクションシャドールート（または「アクションシャドー」）が有効になっている場合、Sailsはカスタムコントローラーアクションのルートを自動的に作成します。これは、手動でルートをバインドする必要性を排除してバックエンドの開発を高速化するために役立つことがあります（特に、開発の初期段階）。有効にすると、コントローラのアクションごとにGET、POST、PUT、およびDELETEルートが生成されます。

たとえば`FooController.js`ファイルが`bar`メソッドを含む場合、`sails.config.blueprints.actions`が有効になっている限り、`/foo/bar`ルートが自動的に作成されます。RESTfulおよびショートカットシャドウとは異なり、暗黙的なアクションごとのシャドウルートでは、モデルに対応したコントローラがある必要はありません。

`index`アクションが存在する場合、そのために抜き出しの追加のルートが作成されます。最終的には、利便性のためにすべての`actions`blueprintが`id`のパスパラメーターをサポートします。

Sails v1.0以降、アクションシャドウは**デフォルトで無効**になっています。本番環境でも使用できます。ただし、本番環境でコントローラ/アクションの自動ルーティングを引き続き使用したい場合は、不注意/意図しないコントローラロジックを誤ってGETリクエストに公開しないよう細心の注意を払わなければなりません。[レスポンスターゲットの構文](https://sailsguides.jp/doc/concepts/routes/custom-routes#?response-target-syntax)を使用して、`/config/routes.js`ファイル内の特定のメソッドまたはパスを簡単に無効にすることができます。たとえば、次のようにします。

```javascript
'POST /user': {response: 'notFound'}
```

##### 注釈

> + アクションルートはすべての HTTPえそっど（GET、PUT、POSTなど）に応答します。`req.method`アクション内でどのメソッドが使用されたかを判断することができます。

##### "Index"アクション

アクションシャドウ（`sails.config.blueprints.actions`）が有効になっていると、追加されたルートシャドウルートは、`index`という名前が付けられたすべてのアクションに対して自動的に公開されます。たとえば`FooController.js`コントローラーファイルが`index`アクションを含む場合、`/foo`シャドウルートがそのアクションに対して自動的にバインドされます。同様に、`api/controllers/foo/index.js`に[スタンドアロンのアクション](https://sailsguides.jp/doc/concepts/actions-and-controllers#?standalone-actions)がある場合は、`/foo`ルートが代表して自動的に公開されます。

<!--
TODO: check on this (it's unclear what point it was trying to get across):

> Note:  Action shadows come with a special exception for top-level standalone actions.  For example, if you have a standalone action at `api/controllers/index.js`, it will be bound to a `/` shadow route automatically.

-->

さまざまなカテゴリのblueprintルートを有効/無効にする方法を含め、[Sailsでblueprintを設定する方法](https://sailsguides.jp/doc/reference/configuration/sails-config-blueprints)の詳細をお読みください。

<docmeta name="displayName" value="Blueprintルート">
