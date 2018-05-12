# タスクの自動化

### 概要

[`tasks/`](https://sailsjs.com/documentation/anatomy/tasks)ディレクトリには、ひとそろいの[Gruntタスク](http://gruntjs.com/creating-tasks)と[設定](http://gruntjs.com/configuring-tasks)が含まれています。

タスクは主に、フロントエンドのアセット（スタイルシート、スクリプト、クライアントサイドのマークアップテンプレートなど）をバンドルするのに便利ですが、[browserify](https://github.com/jmreidy/grunt-browserify)のコンパイルから[データベースマイグレーション](https://www.npmjs.org/package/grunt-db-migrate)まであらゆる種類の繰り返し開発作業を自動化するためにも使用できます。

利便性のためにSailsはいくつかの[デフォルトタスク](https://sailsjs.com/documentation/grunt/default-tasks)をバンドルしていますが、[文字通り何百もの](http://gruntjs.com/plugins)プラグインを選択できます。タスクを使用して最小限の労力で自動化できます。もしあなたが必要なものをまだ誰も作っていないかった場合、[編集](http://gruntjs.com/creating-tasks)し、[自分自身のプラグイン](http://gruntjs.com/creating-plugins)として[npm](http://npmjs.org)に公開することができます。

> 前もって[Grunt](http://gruntjs.com/)を使用していない場合は、[Getting Started](http://gruntjs.com/getting-started)ガイドをチェックしてください。[Gruntfile](http://gruntjs.com/sample-gruntfile)を作成し、Gruntプラグインをインストールして使用する方法についても説明しています。

### アセットパイプライン

アセットパイプラインは、ビューに挿入されるアセットを編成する場所で、`tasks/pipeline.js`ファイル内にあります。これらのアセットを簡単に設定するには、gruntの[タスクファイルの設定](http://gruntjs.com/configuring-tasks#files)と[ワイルドカード/グロブ/スプラットのパターン](http://gruntjs.com/configuring-tasks#globbing-patterns)を使用します。それらは3つのセクションに分かれています。

##### CSSファイルを挿入する

これはHTMLファイルに`<link>`タグとして挿入されるCSSファイルの配列です。これらのタグは、表示される任意のビュー内の、`<!--STYLES--><!--STYLES END-->`コメントの間にに挿入されます。

##### Javascriptファイルを挿入する

これは、あなたのHTMLに`<script>`タグとして注入されるJavascriptファイルの配列です。これらのタグは、表示される任意のビュー内の`<!--SCRIPTS--><!--SCRIPTS END-->`コメントの間に挿入されます。ファイルは配列の順に挿入されます（依存関係のあるファイルの前に依存関係のパスを置く必要があります）。

##### テンプレートファイルを挿入する

これは、jst関数にコンパイルされ、jst.jsファイルに配置されるhtmlファイルの配列です。このファイルはhtmlの`<!--TEMPLATES--><!--TEMPLATES END-->`コメントの間に、`<script>`タグとして挿入されます。

> これらを変更したい場合は、タスク設定用のjsファイル自体にも、gruntのワイルドカード/グロブ/スプラットのパターンとタスクファイルの設定が適用されます。

### タスク設定

設定されたタスクは、実行時にGruntfileが従う一連のルールです。完全にカスタマイズ可能で、[`tasks/config/`](https://sailsjs.com/documentation/anatomy/my-app/tasks/config)ディレクトリにあります。Gruntタスクを変更、省略、または置き換えて、要件に合わせることができます。独自のGruntタスクを追加することもできます。先ほどのディレクトリに`someTask.js`を追加すると新しいタスクが設定され、適切な親タスクに登録してください（`tasks/register/*.js`にあるファイルを参照してください）。ただ、Sailsには設定不要の便利なデフォルトタスクが用意されているということを覚えておいてください。

##### カスタムタスクを設定する

あなたのプロジェクトにカスタムタスクを設定することは非常に簡単で、Gruntの[設定](http://gruntjs.com/api/grunt.config)と[タスクAPI](http://gruntjs.com/api/grunt.task)を使用してタスクをモジュール化することができます。既存のタスクを置き換える新しいタスクを作成する簡単な例を見てみましょう。デフォルトで設定されているアンダースコアテンプレートエンジンの代わりに、Handlebarsテンプレートエンジンを使用したいとしましょう。

* 最初のステップは、ターミナルで次のコマンドを使用してHandlebrsのgruntプラグインをインストールすることです。

```bash
npm install grunt-contrib-handlebars --save-dev
```

* `tasks/config/handlebars.js`に設定ファイルを作成します。ここでhandlebarsの設定を行います。

```javascript
// tasks/config/handlebars.js
// --------------------------------
// handlebar task configuration.

module.exports = function(grunt) {

  // We use the grunt.config api's set method to configure an
  // object to the defined string. In this case the task
  // 'handlebars' will be configured based on the object below.
  grunt.config.set('handlebars', {
    dev: {
      // We will define which template files to inject
      // in tasks/pipeline.js
      files: {
        '.tmp/public/templates.js': require('../pipeline').templateFilesToInject
      }
    }
  });

  // load npm module for handlebars.
  grunt.loadNpmTasks('grunt-contrib-handlebars');
};
```

* アセットパイプラインのソースファイルへのパスを置き換えます。ここでの唯一の変更は、拡張子が.hbsのファイルをhandlebarsが探すのに対し、underscoreのテンプレートは単純なHTMLファイルにすることができます。

```javascript
// tasks/pipeline.js
// --------------------------------
// asset pipeline

var cssFilesToInject = [
  'styles/**/*.css'
];

var jsFilesToInject = [
  'js/socket.io.js',
  'js/sails.io.js',
  'js/connection.example.js',
  'js/**/*.js'
];

// We change this glob pattern to include all files in
// the templates/ direcotry that end in the extension .hbs
var templateFilesToInject = [
  'templates/**/*.hbs'
];

module.exports = {
  cssFilesToInject: cssFilesToInject.map(function(path) {
    return '.tmp/public/' + path;
  }),
  jsFilesToInject: jsFilesToInject.map(function(path) {
    return '.tmp/public/' + path;
  }),
  templateFilesToInject: templateFilesToInject.map(function(path) {
    return 'assets/' + path;
  })
};
```

* handlebarsタスクをcompileAssetsタスクとsyncAssets登録タスクに含めます。これはjstタスクが使用されていた場所で、新たに設定されたhandlebarsタスクに置き換えられます。

```javascript
// tasks/register/compileAssets.js
// --------------------------------
// compile assets registered grunt task

module.exports = function (grunt) {
  grunt.registerTask('compileAssets', [
    'clean:dev',
    'handlebars:dev',       // changed jst task to handlebars task
    'less:dev',
    'copy:dev',
    'coffee:dev'
  ]);
};

// tasks/register/syncAssets.js
// --------------------------------
// synce assets registered grunt task

module.exports = function (grunt) {
  grunt.registerTask('syncAssets', [
    'handlebars:dev',      // changed jst task to handlebars task
    'less:dev',
    'sync:dev',
    'coffee:dev'
  ]);
};
```

* jstタスク設定ファイルを削除します。もはや`tasks/config/jst.js`を使用しないので、取り除くことができます。プロジェクトから削除するだけです。

> 理想的には、プロジェクトとノードの依存関係からプロジェクトを削除する必要があります。これはターミナルでこのコマンドを実行することで達成できます。

```bash
npm uninstall grunt-contrib-jst --save-dev
```

### タスクトリガー

[開発モード](https://next.sailsjs.com/documentation/reference/configuration/sails-config#?sailsconfigenvironment)では、Sailsは`default`タスクを実行します（[`tasks/register/default.js`](https://sailsjs.com/documentation/anatomy/tasks/register/default.js)）。これによりLESSやCoffeeScript、クライアントサイドのJSTテンプレートがコンパイルされ、アプリの動的ビューや静的HTMLファイルから自動的にリンクされます。

プロダクション環境では、Sailsは`prod`タスク（[`tasks/register/prod.js`](https://sailsjs.com/documentation/anatomy/tasks/register/prod.js)）と同じタスクを`default`として実行しますが、アプリのスクリプトとスタイルシートをミニファイする処理も行います。これにより、アプリのロード時間と帯域幅の使用が軽減されます。

これらのタスクトリガは、[`tasks/register/`](https://sailsjs.com/documentation/anatomy/tasks/register)フォルダにある[「基本的な」Gruntタスク](http://gruntjs.com/creating-tasks#basic-tasks)です。以下に、Sailsのすべてのタスクトリガの完全なリファレンスと、それらを起動するコマンドを示します。

##### `sails lift`

**default**タスク（`tasks/register/default.js`）を実行します。

##### `sails lift --prod`

**prod**タスク（`tasks/register/prod.js`）を実行します。

##### `sails www`

参照内の相対パスを使用する`.tmp/public`の代わりに、すべてのアセットを`www`のサブフォルダにコンパイルする**ビルド**タスク（`tasks/register/build.js`）を実行します。これにより、[「wwwミドルウェア」](https://sailsjs.com/documentation/concepts/Middleware)に頼るのではなく、ApacheやNginxで静的コンテンツを提供することができます。

##### `sails www --prod` (production)

**ビルド**タスクと同じことを行いますが、アセットを最適化するbuildProdタスク（`tasks/register/buildProd.js`）を実行します。

NODE_ENVを設定し、同じ名前でtasks/register/にタスクリストを作成することで、他のタスクを実行できます。たとえば、NODE_ENVがQAの場合、sailsはtasks/register/QA.jsがあれば実行します。

<docmeta name="displayName" value="Task automation">
