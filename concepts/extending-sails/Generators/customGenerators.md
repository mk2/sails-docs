# カスタムジェネレーター

<!-- TODO: update this tutorial to reflect how generator names are spat out.  Also update it to explain that you can just delete the package.json file in the newly generated generator if you're not planning on publishing it to npm.  Also bring back in the information that was deleted because the examples were quite out of date (the other content is still good though- see commit history of this file on GitHub  -->

### 概要

カスタム[ジェネレーター](https://sailsguides.jp/doc/concepts/extending-sails/generators)は、Sailsのコマンドライン用のプラグインの一種です。`sails new`や`sails generate`を実行するとき、テテンプレートを通じてSailsプロジェクトに生成されるファイルやその内容をコントロールすることができます。

### ジェネレーターの作成

まずは体験するために、Sailsプロジェクトを作成しましょう。まだ作成していない場合は、ターミナルに移動して次のように入力します。

```sh
sails new my-project
```

次に`cd`で`my-project`へ移動し、Sailsに新しいジェネレーターのテンプレートを吐き出させてください。

```sh
sails generate generator awesome
```

### ジェネレーターの設定

ジェネレーターを有効にするには、先ほど生成したテストプロジェクトの[`.sailsrc`ファイル](https://sailsguides.jp/doc/concepts/configuration/using-sailsrc-files)を介してSailsに伝える必要があります。

既存のジェネレーターを使う場合は、NPMからジェネレーターをインストールして、そのジェネレーターの名前を`.sailsrc`に指定してください。ただ、今はジェネレーターをローカルで開発しているので、直接フォルダに接続します。

```javascript
{
  "generators": {
    "modules": {
    	"awesome": "./my-project/awesome"
    }
  }
}
```

> **注意：** 今のところ、「素晴らしい」としていますが、任意の名前でジェネレーターをマウントすることができます。`.sailsrc`で設定したキー名が、ターミナルからジェネレーターを実行する際の名前になります（たとえば`sails generate awesome`）。


### カスタムジェネレーターを実行する

ジェネレーターを実行するには、その名前を`sails generate`に付け加えて、さらにその後に任意の引数やコマンドラインオプションを続けます。例を示します。

```js
sails generate awesome
```


### NPMへ公開する

ジェネレーターが他のプロジェクトで役立つ場合は、NPMパッケージとして公開することを検討してみてください。（ジェネレーターが必ずオープンソースにならなければいけない、ということではありません。NPMは[プライベートパッケージ](https://docs.npmjs.com/private-modules/intro)もサポートしています。）

まず、`package.json`ファイルを開いて、パッケージ名（たとえば"@my-npm-name/sails-generate-awesome"）や著者（"My Name"）、ライセンス、そして他の情報が正しいことを確認します。（もしわからないのであれば、オープンソースライセンスは"MIT"を使ってください。プライベートなジェネレーターを公開しようとしているのであれば、"UNLICENSED"を使うことで自分の組織の所有にさせることができます。）

> **注意：** まだNPMアカウントを持っていない場合は、[npmjs.com](https://www.npmjs.com/)にアクセスしてアカウントを作成してください。そのあと`npm login`を実行してセットアップします。

準備ができたら、NPMにジェネレーターを公開しましょう。ターミナルのジェネレーターのフォルダにcdで移動し、次のように入力します。

```sh
npm publish
```


### ジェネレーターをインストールする

新しく公開されたジェネレーターを試しに実行するには、サンプルのSailsプロジェクト（`my-project`）にcdで戻り、インラインのジェネレーターを削除し、次を実行します。

```js
npm install @my-npm-name/sails-generate-awesome
```

そしたらサンプルのSailsプロジェクトの`.sailsrc`を変更します（`my-project/.sailsrc`）。

```javascript
{
  "generators": {
    "modules": {
      "awesome": "@my-npm-name/sails-generate-awesome"
    }
  }
}
```

そして最後に次を実行します。

```sh
sails generate awesome
```


<docmeta name="displayName" value="Custom generators">
<docmeta name="displayName_ja" value="カスタムジェネレーター">
