# ヘルパー

バージョン1.0ではすべてのSailsアプリケーションに、Node.jsのコードを複数の場所で共有できる **ヘルパー**というシンプルなユーティリティが組み込まれています。これにより、繰り返しを避けることができ、バグを減らして書き換えを最小限に抑えることで、開発効率を向上させることができます。action2と同様に、これによりアプリケーションのドキュメントを作成するのがより簡単になります。

### 概要

Sailsでは、ヘルパーは繰り返しのコードを別のファイルに分離し、様々な[アクション](https://sailsguides.jp/doc/concepts/actions-and-controllers)、[カスタムレスポンス](https://sailsguides.jp/doc/concepts/extending-sails/custom-responses)、[コマンドライン用スクリプト](https://www.npmjs.com/package/machine-as-script), [単体テスト](https://sailsguides.jp/doc/concepts/testing)、さらには他のヘルパーでコードの再利用するためのおすすめの手法です。もしかしたら、ヘルパーを使用する必要はないかもしれません。実際、最初に必要とはならないかもしれません。しかしコードベースが大きくなるにつれ、ヘルパーはアプリケーションの保守性にとってますます重要になります。（さらに付け加えると、とても便利です。）

たとえば、Node.js/Sailsアプリケーションがクライアントからの要求に応答するためのアクションを作成する過程で、いくつかの場所でコードを繰り返すことがあります。もちろん、バグの多い傾向にあるかもしれません。幸運にもきちんとした解決策があります。重複したコードをカスタムヘルパーへの呼び出しで置き換えるのです。

```javascript
var greeting = await sails.helpers.formatWelcomeMessage('Bubba');
sails.log(greeting);
// => "Hello, Bubba!"
```

> ヘルパーは、コード内のどこからでも呼び出すことができます。ただ、[アプリのインスタンス`sails`](https://sailsguides.jp/doc/reference/application)へアクセスできる場所に限られます。

### ヘルパーの定義方法

シンプルで、良い定義のヘルパーの例を示します。

```javascript
// api/helpers/format-welcome-message.js
module.exports = {

  friendlyName: 'Format welcome message',


  description: 'Return a personalized greeting based on the provided name.',


  inputs: {

    name: {
      type: 'string',
      example: 'Ami',
      description: 'The name of the person to greet.',
      required: true
    }

  },


  fn: async function (inputs, exits) {
    var result = `Hello, ${inputs.name}!`;
    return exits.success(result);
  }

};
```

簡単ですが、このファイルは優れたヘルパーの特徴をいくつか持っています。フレンドリーな名前と説明から始まり、ユーティリティが何をしているのかをすぐに明らかにし、その入力を記述することでユーティリティの使い方をわかりやすくします。さらに、可能な限り最も簡単な方法で個別のタスクを実行します。


> 見覚えがありますか？ヘルパーは[シェルスクリプト](https://sailsguides.jp/doc/concepts/shell-scripts)と[actions2](https://sailsguides.jp/doc/concepts/actions-and-controllers#?actions-2)と同じ仕様に従います。

##### `fn`関数 

ヘルパーのコアは、`fn`関数です。その関数はヘルパーが実行する実際のコードを含む関数です。関数は2つの引数を取ります。`inputs`は入力値の辞書、つまり入力引数です。`exists`はコールバック関数の辞書です。`fn`の仕事は入力引数を利用して処理を行い、提供されたexitsの一つをトリガーし、ヘルパーのコードに制御を戻すことです。`return`を使って呼び出しもとに出力を返す典型的なJavascript関数に対して、ヘルパーは`exits.success()`に結果の値を渡すことに注してください。

##### 入力

ヘルパーで宣言された入力は、典型的なJavascript関数のパラメータに似ています。それらは、コードが処理すべき値を定義します。ただし、標準のJavaScript関数のパラメータとは異なり、入力は自動的に検証されます。ヘルパーが、対応する入力に対して誤った型の入力引数を使用して呼び出されたり、必要な入力の値が欠けているとエラーが発生します。したがって、ヘルパーは自己検証を行うといえます。

ヘルパーへの入力は、`inputs`辞書に定義されます。それぞれの入力定義は、少なくとも`type`プロパティから構成されています。ヘルパーのインプットは次のような型をサポートしています。

* `string` - 文字列
* `number` - 数値（整数も浮動小数点も両方大丈夫）
* `boolean` - `true`もしくは`false`
* `ref` - Javascriptの変数への参照。辞書や配列、関数、ストリームなど、任意の値を指定できます。

これらは、あなたが[モデル属性の定義](https://sailsguides.jp/doc/concepts/models-and-orm/attributes)ですでに慣れているかもしれないデータの型（そして関連する文法）と同じです。もし慣れているのであれば、期待通り、`defaultsTo`プロパティを設定することで、入力のデフォルト値を設定することができます。また、`required: true`を設定することで必須にできたり、`allowNull`を使ったり、より高レベルのバリデーションである`isEmail`のようなルールも使うことができます。

ヘルパーを呼び出すときに渡す引数は、そのヘルパーが宣言した`inputs`のキーの順序に対応します。また、入力引数を名前で渡す場合は、次のように`.with()`を使用します。

```javascript
var greeting = await sails.helpers.formatWelcomeMessage.with({ name: 'Bubba' });
```

##### Exits

Exitsは、ヘルパーが持つことができる、様々な可能性のある結果すべてを説明します。すべてのヘルパーが自動的に`error`と`success`というexitsをサポートします。ヘルパーを呼び出すとき、正常に終了すれば`fn`は`success`をトリガーします。しかし、[`.tolerate()`](https://sailsguides.jp/doc/reference/waterline-orm/queries/tolerate)が使われずにエラーが投げられた場合、`fn`は`success`以外のexitをトリガーします。

必要に応じて、他のカスタムexits（「例外」と呼ばれます）を公開し、ヘルパーを呼び出すユーザーのコードが特定の例外的なケースを処理できるようにすることもできます。これにより、エラーを宣言してネゴシエートするのが簡単になり、コードの透過性とメンテナス性が保証されます。

> ヘルパーの例外（カスタムexits）は、`exits`辞書に定義されます。すべてのカスタム例外に`description`プロパティを指定するのが良いプラクティスです。

カスタムExit`emailAddressInUse`を公開するヘルパー、「Invite new user」を想像してみてください。提供されたemailがすでに存在する場合、ヘルパーの`fn`はこのカスタムexitをトリガーし、ユーザーのコードがこの特定のシナリオを処理できるようにします。結果の値を混乱させたり、余計な`try/catch`ブロックに頼ったりすることはありません。

例として、このヘルパーが独自の「badRequest」exitを持つアクション内から呼び出された場合を示します。

```javascript
var newUserId = sails.helpers.inviteNewUser('bubba@hawtmail.com')
.intercept('emailAddressInUse', 'badRequest');
```

> 上記のより簡潔なものを書くとこうなります。
>
> ```javascript
> .intercept('emailAddressInUse', (err)=>{
>   return 'badRequest';
> });
> ```
>
> [.intercept()](https://sailsguides.jp/doc/reference/waterline-orm/queries/intercept)とは？それは単なるショートカットであり、独自のtry/catchブロックを作成し、エラーを手作業で管理する必要は全くありません。

内部的には、[special exit signal]()を投げたり、exitコールバック（例:`exits.success('foo')`）を呼び出すなどして、ヘルパーの`fn`がexitsの一つをトリガーする責任を負います。もしヘルパーがサクセスexitを通して結果（例：`'foo'`）を返すのであれば、それはヘルパーの戻り値となります。

> 非成功exitsについては、Sailsは必要に応じてexitの定義済みのdescriptionを使用して、適切なJavascriptのエラーインスタンスを自動的に作成します。

##### 同期型ヘルパー

デフォルトでは、すべてのヘルパーを非同期とみなされます。これはデフォルトの安全な前提ですが、いつもそうであるとは限りません。特定のケースにおいては、パフォーマンスを最適化するために、`sync: true`プロパティを使うことでSailsに伝えることができます。

ヘルパーの`fn`内のコードがすべて同期していることがわかっている場合は、トップレベルの`sync`プロパティを`true`に設定することができます。これにより、ユーザーのコードは[`await`無しでヘルパーを呼び出す](https//sailsguides.jp/doc/concepts/helpers#?synchronous-usage)ことができるようになります。（`fn: async function`を`fn: function`に変更することを覚えておいてください。）

> 注意点として、非同期ヘルパーを`await`無しで呼び出すと、動かないです。

##### `req`にヘルパーでアクセスする

リクエストヘッダーをパースするようなヘルパーを設計する場合、特にアクション内での使用のために、既存のメソッドや[リクエストオブジェクト](https://sailsguides.jp/doc/reference/request-req)のプロパティを利用したいと思うでしょう。アクション内のコードで、`req`をヘルパーに渡すための最も簡単な方法は`type: 'ref'`入力を定義することです。

```javascript
inputs: {

  req: {
    type: 'ref',
    description: 'The current incoming request (req).',
    required: true
  }

}
```

次に、アクション内でヘルパーを使うために、次のようなコードを書きます。

```javascript
var headers = await sails.helpers.parseMyHeaders(req);
```

### ヘルパーの生成

Sailsには、自動的に新しいヘルパーを作成するための組み込みジェネレーターが用意されています。

```bash
sails generate helper foo-bar
```

これにより、`sails.helpers.fooBar`としてコード内からアクセスできるファイルが`api/helpers/foo-bar.js`に作成されます。作成されるファイルは、入力がなく、デフォルトexits（`success`と`error`）があり、実行時に即座に`success`exitをトリガーするだけの一般的なヘルパーになります。

### ヘルパーを呼び出す

Sailsアプリケーションが読み込まれるたびに、`api/helpers`にあるすべてのファイルが検索され、関数としてコンパイルされ、`sails.helpers`辞書に、ファイル名のキャメルケースバージョンを利用して格納されます。`await`を使って入力引数を渡して呼び出すだけで、コードからどのヘルパーも起動できます。

```javascript
var result = await sails.helpers.formatWelcomeMessage('Dolly');
sails.log('Ok it worked!  The result is:', result);
```

> これは、すでにあなたがご存知かもしれない`.create()`のような[モデルメソッド](https://sailsguides.jp/doc/concepts/models-and-orm/models)とほぼ同じ使い方になります。

##### 同期型の使い方

ヘルパーが`sync`プロパティを宣言した場合は、次のように`await`無しで呼び出すことができます。

```javascript
var greeting = sails.helpers.formatWelcomeMessage('Timothy');
```

しかし、`await`を削除する前に、ヘルパーが実際に同期していることを確認してください。（そうでないと、`await`無しの場合には決してヘルパーが実行されません！）

### 例外処理

よりきめ細かなエラー処理（あまり大したエラーではない場合でも）、エラーコードをいくつか設定し、それを盗み見ることができます。この方法はうまくいきますが、時間がかかり追跡が難しい場合があります。

幸運なことに、Sailsのヘルパーはそれらを2つのステップとして捉えています。より詳しい情報は、[.tolerate()]()や[.intercept()]()、[special exit signals]()を参照してください。

<!--
For future reference, see https://github.com/balderdashy/sails-docs/commit/61f0039d26021c8abf4873aa675c409372dc2f8f
for the original content of these docs.
-->

##### 多かれ少なかれ、必要になること

この例の使用法は一例ですが、`notUnique`のようなカスタムexitsに頼るの非常に役に立ち、かつ簡単なシナリオです。それでも、すべてのカスタムexitを毎回扱いたくはないはずです。理想的には、実際に必要な場合は、ユーザーコード内のカスタムexitを処理するだけで済みます。何らかの機能を実装するかどうか、ユーザーエクスペリエンスを向上させるか、より良い内部エラーメッセージを提供するかどうかに関係なく。

幸いなことに、Sailsのヘルパーは「自動exit転送」をサポートしています。つまり、ユーザーのコードは場合に応じて好きなだけカスタムexitをいくつでも、あるいは多くのものに統合を選択できることを意味します。言い換えると、ヘルパーを呼び出すときに`notUnique`が必要ない場合は、カスタムexitを完全に無視しても問題ありません。そうすれば、コードは可能な限り簡潔かつ直感的になります。事情が変わった場合には、いつでもカスタムExitを処理するためにコードを戻すことができます。

### 次のステップ
### Next steps

+ Node.js/Sailsアプリケーションのヘルパーの[実践的な例をみる](https://sailsguides.jp/doc/concepts/helpers/example-helper)
+ `sails-hook-organics`（Web Appテンプレートにバンドルされています）には、多くの一般的な使用例に対していくつかの無料のオープンソースおよびMITライセンスヘルパーが付属しています。[見てみましょう！](https://npmjs.com/package/sails-hook-organics)
+ もしヘルパーがよくわからなかったり、チュートリアルやサンプルをもっと見たい場合は、[ここをクリックしてください。](https://sailsjs.com/support)

<docmeta name="displayName" value="Helpers">
<docmeta name="displayName_ja" value="ヘルパー">
<docmeta name="nextUpLink" value="/documentation/concepts/deployment">
<docmeta name="nextUpName" value="Deployment">
