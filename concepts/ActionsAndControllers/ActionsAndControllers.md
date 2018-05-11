# アクションとコントローラ

### 概要

_アクション_ は、Webブラウザ、モバイルアプリケーション、またはサーバーと通信することができる他のシステムからの*要求*に応答するSailsアプリケーションの基礎的なオブジェクトです。しばしば[モデル](https://sailsjs.com/documentation/concepts/models-and-orm)と[ビュー](https://sailsjs.com/documentation/concepts/views)の仲介者として動作します。例外的な場合を除き、アクションはプロジェクトの[ビジネスロジック](http://en.wikipedia.org/wiki/Business_logic)の大部分を編成します。

アクションはアプリケーションの[routes](https://sailsjs.com/documentation/concepts/Routes)にバインドされるため、ユーザーエージェントが特定のURLを要求すると、バインドされたアクションが実行されてビジネスロジックが実行され、応答が送信されます。例えば、`GET /hello`というルートをアプリケーションのアクションとして次のようにバインドできます。

```javascript
async function (req, res) {
  return res.send('Hi there!');
}
```

ウェブブラウザでサーバー上で動いているアプリの`/hello`というURLを開くと、そのページには「Hi there!」というメッセージが表示されます。

### アクションはどこに定義されていますか？

アクションは、`api/controllers/`フォルダとサブフォルダで定義されます（コントローラについては少し詳しく説明します）。ファイルがアクションとして認識されるためには、ファイルは_ケバブケース_（小文字の英字、数字、およびダッシュのみ）でなければなりません。Sailsのアクションを参照する場合（たとえば、[ルートにバインドする場合](https://sailsjs.com/documentation/concepts/routes/custom-routes#?action-target-syntax)）、`api/controllers`への相対パスを、ファイル拡張子なしで使用します。例えば、`api/controllers/user/find.js`というファイルは、`user/find`というアクションを示します。

##### アクションのファイル拡張子

アクションは、`.md`（マークダウン）と`.txt`（テキスト）以外のファイル拡張子を持つことができます。デフォルトでは、Sailsは`.js`ファイルの解釈方法しか知りませんが、[CoffeeScript](https://sailsjs.com/documentation/tutorials/using-coffee-script)や[TypeScript](https://sailsjs.com/documentation/tutorials/using-type-script)などを使用するようにアプリケーションをカスタマイズすることもできます。

### アクションファイルはどのようなものですか？

アクションファイルは、_classic_ と _actions2_ の2つの形式のいずれかを使用できます。

##### Classic actions

Sailsアクションを作成する従来の方法は、関数として宣言することです。クライアントがそのアクションにバインドされたルートを要求すると、[incoming request object](https://sailsjs.com/documentation/reference/request-req)を第1引数（通常は名前`req`）として使用し、[outgoing response object](https://sailsjs.com/documentation/reference/response-res)を第2引数（通常は名前`res`）として使用して関数を呼び出します。以下は、ユーザーをIDで検索し、「ようこそ」ビューを表示するか、ユーザーが見つからない場合にサインアップページにリダイレクトするアクション関数の例です。

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

> machine-as-actionは[request object](https://sailsjs.com/documentation/reference/request-req)へのアクセスを`this.req`として提供することに注してください。

<!--
Removed in order to reduce the amount of information:  (Mike nov 14, 2017)

and to the Sails application object (in case you don&rsquo;t have [globals](https://sailsjs.com/documentation/concepts/globals) turned on) as `this.sails`.
-->

classic actionsで実装を行う場合は、厳密にはタイピングが少なくなります。しかし、actions2はいくつかの利点があります。

 * あなたが書いたコートは`req`や`res`に直接依存しません。再利用したり、[helper](https://sailsjs.com/documentation/concepts/helpers)として抽象化したりするのが簡単になります。
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

### Controllers

The quickest way to get started writing Sails apps is to organize your actions into _controller files_.  A controller file is a [_PascalCased_](https://en.wikipedia.org/wiki/PascalCase) file whose name must end in `Controller`, containing a dictionary of actions.  For example, a  "User controller" could be created at `api/controllers/UserController.js` file containing:

```javascript
module.exports = {
  login: function (req, res) { ... },
  logout: function (req, res) { ... },
  signup: function (req, res) { ... },
};
```

You can use [`sails generate controller`](https://sailsjs.com/documentation/reference/command-line-interface/sails-generate#?sails-generate-controller-foo-action-1-action-2) to quickly create a controller file.

##### File extensions for controllers

A controller can have any file extension besides `.md` (Markdown) and `.txt` (text).  By default, Sails only knows how to interpret `.js` files, but you can customize your app to use things like [CoffeeScript](https://sailsjs.com/documentation/tutorials/using-coffee-script) or [TypeScript](https://sailsjs.com/documentation/tutorials/using-type-script) as well.


### Standalone actions

For larger, more mature apps, _standalone actions_ may be a better approach than controller files.  In this scheme, rather than having multiple actions living in a single file, each action is in its own file in an appropriate subfolder of `api/controllers`.  For example, the following file structure would be equivalent to the  `UserController.js` file:

```
api/
 controllers/
  user/
   login.js
   logout.js
   signup.js
```

where each of the three Javascript files exports a `req, res` function or an actions2 definition.

Using standalone actions has several advantages over controller files:

* It's easier to keep track of the actions that your app contains, by simply looking at the files contained in a folder rather than scanning through the code in a controller file.
* Each action file is small and easy to maintain, whereas controller files tend to grow as your app grows.
* [Routing to standalone actions](https://sailsjs.com/documentation/concepts/routes/custom-routes#?action-target-syntax) in nested subfolders is more intuitive than with nested controller files (`foo/bar/baz.js` vs. `foo/BarController.baz`).

* Blueprint index routes apply to top-level standalone actions, so you can create an `api/controllers/index.js` file and have it automatically bound to your app&rsquo;s `/` route (as opposed to having to create an arbitrary controller file to hold the root action).


### Keeping it lean

In the tradition of most MVC frameworks, mature Sails apps usually have "thin" controllers -- that is, your action code ends up lean, because reusable code has been moved into [helpers](https://sailsjs.com/documentation/concepts/helpers) or occasionally even extracted into separate node modules.  This approach can definitely make your app easier to maintain as it grows in complexity.

But at the same time, extrapolating code into reusable helpers _too early_ can cause maintainence issues that waste time and productivity.  So the right answer lies somewhere in the middle.

Sails recommends this general rule of thumb:  **Wait until you're about to use the same piece of code for the _third_ time before you extrapolate it into a separate helper.**  But as with any dogma, use your judgement!  If the code in question is very long or complex, then it might make sense to pull it out into helper a helper much sooner.  Conversely, if you know what you're building is a quick, throwaway prototype, you might just copy and paste the code to save time.

> Whether you're developing for passion or profit, at the end of the day, the goal is to make the best possible use of your time as an engineer.  Some days that means getting more code written, and other days it means looking out for the long-term maintainability of the project.  If you're not sure which of these goals is more important at your current stage of development, you might take a step back and give it some thought.  (Better yet, have a chat with the rest of your team or [other folks building apps on Node.js/Sails](https://sailsjs.com/support).)

<docmeta name="displayName" value="Actions and controllers">
<docmeta name="nextUpLink" value="/documentation/concepts/views">
<docmeta name="nextUpName" value="Views">
