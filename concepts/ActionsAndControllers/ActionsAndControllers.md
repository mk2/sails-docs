# アクションとコントローラ

### 概要

_アクション_ は、Webブラウザ、モバイルアプリケーション、またはサーバーと通信することができる他のシステムからの*要求*に応答するSailsアプリケーションの基礎的なオブジェクトです。しばしば[モデル](https://sailsguides.jp/doc/concepts/models-and-orm)と[ビュー](https://sailsguides.jp/doc/concepts/views)の仲介者として動作します。例外的な場合を除き、アクションはプロジェクトの[ビジネスロジック](https://ja.wikipedia.org/wiki/%E3%83%93%E3%82%B8%E3%83%8D%E3%82%B9%E3%83%AD%E3%82%B8%E3%83%83%E3%82%AF)の大部分を編成します。

アクションはアプリケーションの[routes](https://sailsguides.jp/doc/concepts/routes)にバインドされるため、ユーザーエージェントが特定のURLを要求すると、バインドされたアクションが実行されてビジネスロジックが実行され、応答が送信されます。例えば、`GET /hello`というルートをアプリケーションのアクションとして次のようにバインドできます。

```javascript
async function (req, res) {
  return res.send('Hi there!');
}
```

ウェブブラウザでサーバー上で動いているアプリの`/hello`というURLを開くと、そのページには「Hi there!」というメッセージが表示されます。

### アクションはどこに定義されていますか？

アクションは、`api/controllers/`フォルダとサブフォルダで定義されます（コントローラについては少し詳しく説明します）。ファイルがアクションとして認識されるためには、ファイルは_ケバブケース_（小文字の英字、数字、およびダッシュのみ）でなければなりません。Sailsのアクションを参照する場合（たとえば、[ルートにバインドする場合](https://sailsguides.jp/doc/concepts/routes/custom-routes#?action-target-syntax)）、`api/controllers`への相対パスを、ファイル拡張子なしで使用します。例えば、`api/controllers/user/find.js`というファイルは、`user/find`というアクションを示します。

##### アクションのファイル拡張子

アクションは、`.md`（マークダウン）と`.txt`（テキスト）以外のファイル拡張子を持つことができます。デフォルトでは、Sailsは`.js`ファイルの解釈方法しか知りませんが、[CoffeeScript](https://sailsguides.jp/doc/tutorials/using-coffee-script)や[TypeScript](https://sailsguides.jp/doc/tutorials/using-type-script)などを使用するようにアプリケーションをカスタマイズすることもできます。

### アクションファイルはどのようなものですか？

アクションファイルは、_classic_ と _actions2_ の2つの形式のいずれかを使用できます。

##### Classic actions

Sailsアクションを作成する従来の方法は、関数として宣言することです。クライアントがそのアクションにバインドされたルートを要求すると、[incoming request object](https://sailsguides.jp/doc/reference/request-req)を第1引数（通常は名前`req`）として使用し、[outgoing response object](https://sailsguides.jp/doc/reference/response-res)を第2引数（通常は名前`res`）として使用して関数を呼び出します。以下は、ユーザーをIDで検索し、「ようこそ」ビューを表示するか、ユーザーが見つからない場合にサインアップページにリダイレクトするアクション関数の例です。

```javascript
module.exports = async function welcomeUser (req, res) {

  // Get the `userId` parameter from the request.
  // This could have been set on the querystring, in
  // the request body, or as part of the URL used to
  // make the request.
  var userId = req.param('userId');

   // If no `userId` was specified, or it wasn't a number, return an error.
  if (!_.isNumeric(userId)) {
    return res.badRequest(new Error('No user ID specified!'));
  }

  // Look up the user whose ID was specified in the request.
  var user = await User.findOne({ id: userId });

  // If no user was found, redirect to signup.
  if (!user) { return res.redirect('/signup' );

  // Display the welcome view, setting the view variable
  // named "name" to the value of the user's name.
  return res.view('welcome', {name: user.name});

}
```

##### action2

アクションを作成するための、より構造化された別の方法は、より現代的な（action2）構文で記述することです。Sailsヘルパーと同じように、宣言的な定義（machine）でアクションを定義することができます。それは基本的にセルフドキュメントで、セルフバリデーティングです。さきほどと同じアクションをactions2形式で書き直してみましょう。

```javascript
module.exports = {

   friendlyName: 'Welcome user',

   description: 'Look up the specified user and welcome them, or redirect to a signup page if no user was found.',

   inputs: {
      userId: {
        description: 'The ID of the user to look up.',
        // By declaring a numeric example, Sails will automatically respond with `res.badRequest`
        // if the `userId` parameter is not a number.
        type: 'number',
        // By making the `userId` parameter required, Sails will automatically respond with
        // `res.badRequest` if it's left out.
        required: true
      }
   },

   exits: {
      success: {
        responseType: 'view',
        viewTemplatePath: 'pages/welcome'
      },
      notFound: {
        description: 'No user with the specified ID was found in the database.',
        responseType: 'notFound'
      }
   },

   fn: async function (inputs, exits) {

      // Look up the user whose ID was specified in the request.
      // Note that we don't have to validate that `userId` is a number;
      // the machine runner does this for us and returns `badRequest`
      // if validation fails.
      var user = await User.findOne({ id: inputs.userId });

      // If no user was found, respond "notFound" (like calling `res.notFound()`)
      if (!user) { return exits.notFound(); }

      // Display the welcome view.
      return exits.success({name: user.name});
   }
};
```

Sailsは[machine-as-action](https://github.com/treelinehq/machine-as-action)を利用して、上記の例のようにmachineからルート処理機能を自動的に作成します。詳細については、[machine-as-actionドキュメント](https://github.com/treelinehq/machine-as-action#customizing-the-response)を参照してください。

> machine-as-actionは[request object](https://sailsguides.jp/doc/reference/request-req)へのアクセスを`this.req`として提供することに注意してください。

<!--
Removed in order to reduce the amount of information:  (Mike nov 14, 2017)

and to the Sails application object (in case you don&rsquo;t have [globals](https://sailsguides.jp/doc/concepts/globals) turned on) as `this.sails`.
-->

classic actionsで実装を行う場合は、厳密にはタイピングが少なくなります。しかし、actions2はいくつかの利点があります。

 * コードは`req`や`res`に直接依存しません。再利用したり、[helper](https://sailsguides.jp/doc/concepts/helpers)として抽象化したりするのが簡単になります。
 * アクションが想定するリクエストパラメータの名前と型を、すばやく特定できることを保証します。そして、アクションが実行される前に自動的にリクエストパラメータに対する検証が行われます。
 * コードを読み解くことなく、起こりうるアクションの全実行結果を見ることができます。

簡単に言えば、コードは後で再利用して変更するのが容易になるように標準化されます。また、アクションのパラメータを事前に宣言するので、特別な問題やセキュリティホールが発生する可能性は非常に低くなります。

###### Exitシグナル

アクション、ヘルパー、またはスクリプトでは、何かをスローすると`error` exitがデフォルトでトリガーされます。他のexitをトリガーしたい場合は、「特別なexitシグナル」を出すことで可能です。これは、文字列（exitの名前）か、キーとしてexitの名前を持ち値として出力データを持つオブジェクト、のいずれかになります。例えば通常構文の代わりに下記のように書けます。

```javascript
return exits.hasConflictingCourses();
```

省略表現を使うことができます。

```javascript
throw 'hasConflictingCourses';
```

もしくは、出力データを含める場合は次のようになります。

```javascript
throw { hasConflictingCourses: ['CS 301', 'M 402'] };
```

わかりやすい省略表現に加えて、Exitシグナルは`for`ループや`forEach`や他の途中の場合でも、特定のexitから抜け出したいというような時に特に便利です。

### コントローラー

Sailsアプリケーションの作成を開始する最も簡単な方法は、あなたのアクションをコントローラファイルに編成することです。コントローラファイルは[パスカルケース](https://ja.wikipedia.org/wiki/%E3%82%AD%E3%83%A3%E3%83%A1%E3%83%AB%E3%82%B1%E3%83%BC%E3%82%B9)で命名されたファイルで、ファイル名は`Controller`で終わっている必要があります。またそのファイルはアクションのディクショナリ構造を含んでいる必要があります。
例えば、「ユーザーコントローラー」を`api/controllers/UserController.js`として作った場合、そのファイルは下記の内容を含んでいます。

```javascript
module.exports = {
  login: function (req, res) { ... },
  logout: function (req, res) { ... },
  signup: function (req, res) { ... },
};
```

また、[`sails generate controller`](https://sailsguides.jp/doc/reference/command-line-interface/sails-generate#?sails-generate-controller-foo-action-1-action-2)を使うことで、すばやくコントローラーファイルを作成することができます。

##### コントローラーのファイル拡張子

コントローラは、`.md`（マークダウン）と`.txt`（テキスト）以外のファイル拡張子を持つことができます。デフォルトでは、Sailsは`.js`ファイルの解釈方法しか知りませんが、[CoffeeScript](https://sailsguides.jp/doc/tutorials/using-coffee-script)や[TypeScript](https://sailsguides.jp/doc/tutorials/using-type-script)などを使用するようにアプリケーションをカスタマイズすることもできます。

### スタンドアロンアクション

大規模で成熟したアプリの場合、スタンドアロンアクションはコントローラファイルよりも優れたアプローチです。この方法では、1つのファイルに複数のアクションが存在するのではなく、それぞれのファイルが`api/controllers`のサブフォルダ内のファイルとして存在します。例えば、次のファイル構造は`UserController.js`ファイルと同じ意味合いを持ちます。

```
api/
 controllers/
  user/
   login.js
   logout.js
   signup.js
```

3つのJavascriptファイルのそれぞれが`req, res`関数またはactions2の定義をエクスポートします。

スタンドアロンアクションを使用すると、コントローラーファイルに比べていくつかの利点があります。

* コントローラーファイル内のコードを読み解くのではなく、フォルダに含まれるファイルを調べるだけで、アプリケーションのアクションを調べる方が簡単です。
* 各アクションファイルは小さく、保守が簡単ですが、コントローラーファイルはアプリの成長に伴って大きくなる傾向があります。
* [スタンドアロンアクションへのルーティング](https://sailsguides.jp/doc/concepts/routes/custom-routes#?action-target-syntax)は、ネストされたコントローラファイルよりも直観的です（`foo/bar/baz.js` 対 `foo/BarController.baz`）。
* Blueprintインデックスルートはトップレベルのスタンドアロンアクションに適用されるため、`api/controllers/index.js`ファイルを作成してアプリの`/`ルートに自動的にバインドさせることができます（rootアクションを保持するコントローラーファイルを作成する必要がありません）。

### leanを保つ

MVCフレームワークの伝統に従えば、成熟したSailsアプリケーションはたいてい「薄い」コントローラを持ちます。つまり、再利用可能なコードが[ヘルパー](https://sailsguides.jp/doc/concepts/helpers)に移動されたり、別のノードモジュールに抽出されたりすることがあります。このアプローチでは、複雑さが増すにつれてアプリケーションをより簡単に保守することができます。

しかし同時に、再利用可能なヘルパーにコードを外挿することは、時間と生産性を犠牲にする保守の問題をあまりに早く引き起こす可能性があります。そのため正しい答えは真ん中のどこかにあります。

Sailsは、次の一般的な経験則をお勧めします。**別のヘルパーにコードを外挿する前に、同じコードが3回出てくることを待つ。** しかし、どんなドグマと同様に、自分の判断で行うようにしてください！問題のコードが非常に長く複雑な場合は、それをヘルパーのヘルパーにもっと早く引き出すことが理にかなっているかもしれません。逆に、構築しているものが素早く使い捨てのプロトタイプであることが分かっている場合は、コードをコピーして貼り付けて時間を節約できます。

> あなたが情熱や利益のために開発しているかどうかにかかわらず、最終目標は、エンジニアとしての時間を最大限に活用することです。ある日はたくさんのコードを書くことになるかもしれないし、また別の日はプロジェクトの長期的な保守性に気を配ることになるかもしれません。現在の開発段階でこれらの目標のどれが重要かわからない場合は、一歩退いて考えてみてください。（チームの他の人たちや[Node.js / Sails上のアプリケーションを構築している人たち](https://sailsjs.com/support)とチャットをするのは良いことです。）

<docmeta name="displayName" value="Actions and controllers">
<docmeta name="displayName_ja" value="アクションとコントローラ">
<docmeta name="nextUpLink" value="/documentation/concepts/views">
<docmeta name="nextUpName" value="Views">
