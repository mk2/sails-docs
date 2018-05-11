# デフォルトタスク

### 概要

Sailsにバンドルされているアセットパイプラインは、プロジェクトの一貫性と生産性を高めるために設計された従来のデフォルトで設定されたGruntタスクのセットです。フロントエンドのアセットワークフロー全体は完全にカスタマイズ可能ですが、一方既定のタスクもそのまま利用できます。Sailsは必要に応じて、簡単に[新しいタスクを設定する](https://sailsjs.com/documentation/concepts/assets/task-automation#?task-configuration)ことができます。

次の項目は、デフォルトでSailsに存在するGruntの設定です。
- 自動LESSコンパイル
- 自動JSTコンパイル
- 自動Coffeescriptコンパイル
- キャッシュ無効化（リソースが変更された際に自動でウェブサーバー上のリソースを参照させる）
- 任意の自動アセット注入、ミニフィケーション、連結
- Web対応の公開ディレクトリの作成
- ファイルの監視と同期
- プロダクション環境でのクライアントサイドのJavaScriptのトランスパイルにより、幅広いブラウザでES6以上の構文を使用することが出来る
- プロダクション環境でのアセット最適化


### デフォルトのGruntタスク

次に示すのは、Sailsの新規プロジェクトに含まれているGruntタスクのお一覧です。

##### clean

> このgruntタスクは、Sailsプロジェクトの`.tmp/public/`の中身を消すように設定されています。

> [使用方法](https://github.com/gruntjs/grunt-contrib-clean)

##### coffee

> `assets/js/`にあるcoffeescriptのファイルをJavascriptへコンパイルし、`.tmp/public/js/`に配置します。

> [使用方法](https://github.com/gruntjs/grunt-contrib-coffee)

##### hash

> キャッシュ無効化のために、ファイル名の末尾にユニークなハッシュを作成して追加します。

> [使用方法](https://github.com/jgallen23/grunt-hash/tree/0.5.0#grunt-hash)

##### concat

> JavaScriptとcssファイルを連結し、`.tmp/public/concat/`に保存します。

> [使用方法](https://github.com/gruntjs/grunt-contrib-concat)

##### copy

> **dev task config**
> coffeescriptとlessファイルを除き、すべてのディレクトリとファイルを、アセットフォルダから`.tmp/public/`ディレクトリへコピーします。

> **build task config**
> すべてのディレクトリとファイルを、`.tmp/public`ディレクトリから`www`ディレクトリへコピーします。

> [使用方法](https://github.com/gruntjs/grunt-contrib-copy)

##### cssmin

> cssファイルをミニファイし、`.tmp/public/min/`ディレクトリへ配置します。

> [使用方法](https://github.com/gruntjs/grunt-contrib-cssmin)

##### jst

> アンダースコアテンプレートを`.jst`ファイルへ事前コンパイルします。（つまり、HTMLテンプレートファイルを小さなJavascript関数へ変換します）。これにより、クライアント側でのテンプレートレンダリングが高速化し、帯域幅の使用が削減されます。

> [使用方法](https://github.com/gruntjs/grunt-contrib-jst)

##### less

> LESSファイルをCSSファイルにコンパイルします。`assets/styles/importer.less`のみがコンパイルされます。これにより、自分自身の順序を制御できます。つまり、他のスタイルシートの前に、依存関係、ミックスイン、変数、リセットなどをインポートすることができます。

> [使用方法](https://github.com/gruntjs/grunt-contrib-less)

##### sails-linker

> JavaScriptファイルの`<script>`タグとcssファイルの`<link>`タグは、自動的に挿入されます。また、`<script>`タグを使用して事前コンパイルされたテンプレートを含む出力ファイルは自動でリンクします。このタスクの詳細な説明は、[ここ](https://github.com/balderdashy/sails-generate-frontend/blob/master/docs/overview.md#a-litte-bit-more-about-sails-linking)にありますが、一番忘れてはいけないことは、スクリプトとスタイルシートの注入は`<!--SCRIPTS--><!--SCRIPTS END-->`もしくは`<!--STYLES--><!--STYLES END-->`タグが含まれているファイルで**のみ**行われます。これらは新規Sailsプロジェクトのデフォルト**views/layouts/layout.ejs**ファイルに含まれています。もしlinkerをプロジェクトで使用したくない場合は、単にそれらのタグを削除するだけです。

> [使用方法](https://github.com/Zolmeister/grunt-sails-linker)

##### sync

> ディレクトリを同期させておくためのgruntタスクです。grunt-contrib-copyによく似ていますが、実際に変更されたファイルだけをコピーしようとします。特に、`assets/`フォルダから`.tmp/public/`へファイルを同期し、既に存在するものは上書きします。

> [使用方法](https://github.com/tomusdrw/grunt-sync)

##### babel

> このgruntタスクは、フロントエンドのJavascriptファイルにあるES6以上の構文を、古いブラウザと互換性のあるコードに変換するように設定されています。

> [使用方法](https://github.com/babel/grunt-babel)

##### uglify

> クライアントサイドのJavaScriptアセットをミニファイします。デフォルトでは、このタスクは関数名と変数名のすべてを "mangle"します（それらをもっと短い名前に変更するか、完全に削除することに注意してください）。これは通常、コードを大幅に小さくするため望ましいことですが、場合によっては予期しない結果につながる可能性があります（特に、オブジェクトのコンストラクタに特定の名前があることが予想される場合）。この動作を無効化ないし変更するには、このタスクを使用するときに[`mangle`オプション](https://www.npmjs.com/package/uglify-es#mangle-properties-options)を使用します。

> [使用方法](https://github.com/gruntjs/grunt-contrib-uglify/tree/harmony)

##### watch

> パターンによって監視されたファイルに追加、変更、または削除があるたびに、あらかじめ定義されたタスクを実行します。`assets/`フォルダ内のファイル変更を監視し、適切なタスクを再実行します（例えばlessやjstのコンパイルなど）。これによってSailsサーバーを再起動することなくアプリに反映されたアセットの変更を確認することができます。

> [使用方法](https://github.com/gruntjs/grunt-contrib-watch)


<docmeta name="displayName" value="Default tasks">
