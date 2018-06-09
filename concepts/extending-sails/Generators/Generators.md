# ジェネレーター

Sailsの大きな部分は、他のフレームワークと同様に、繰り返しのタスクを自動化することです。**ジェネレーター** も例外ではありません。Sailsプロジェクト用の新しいファイルを生成するたびに、Sailsコマンドラインインターフェイスに力を与えています。実際、あなたやチームの誰かが、おそらくジェネレーターを使って最新のSailsプロジェクトを作成したでしょう。

以下のように入力するとき、

```sh
sails new my-project
```

sailsは組み込みの「新しい」ジェネレーターを使って、アプリケーションのテンプレートを選ぶよう指示し、Sailsアプリケーションの初期状態のフォルダ構造を吐き出します。

```javascript
my-project
  ├── api/
  │   ├─ controllers/
  │   ├─ helpers/
  │   └─ models/
  ├── assets/
  │   └─ …
  ├── config/
  │   └─ …
  ├── views/
  │   └─ …
  ├── .gitignore
  …
  ├── package.json
  └── README.md
```

この慣習的な（標準の）フォルダ構造は、フレームワークを利用する大きな利点のひとつです。同時に、トレードオフのひとつでもあります。（チームや組織が別の慣習に固執している場合はどうするのでしょうか？）

幸いなことに、Sailsのv0.11以降ではジェネレーターは拡張性があり、プロジェクトリポジトリにチェックインしたり、再利用のためにNPMに公開することが簡単にできます。

`sails new`や`sails generate`をコマンドラインから実行したときに、Sailsのジェネレーターで何をやるかを完全にカスタマイズすることができます。新しいアプリケーションや新たに生成されたモジュールを強化することで、カスタムジェネレーターはたくさんのクールなことを実行できるようになります。

- 組織全体で、すべての新しいアプリケーションにための規約とボイラープレートロジックを標準化する
- デフォルトの.eslintrcファイルでルールを交換する
- 新しいプロジェクトで、あせっとぱぷラインがどのように動くかをカスタマイズする
- 全くことなるアセットパイプライン（たとえば[Gulp](http://gulpjs.com/)や[webpack](https://webpack.github.io/)）を使う
- [別のデフォルトビューエンジン](https://sailsguides.jp/doc/concepts/views/view-engines)を使う
- カスタムデプロイを自動化する（たとえば、1人の顧客ごとに1台のサーバーを持つ、専用のアプリケーション）
- package.jsonファイルに異なる依存関係のセットを含める
- TypescriptやCoffeeScriptのようなトランスパイルする言語でファイルを生成する
- 英語以外の言語で、ドキュメントとコメントを書く
- すべてのコードファイルで、猫のアスキーアートを含む（もしくはライセンスヘッダーなど）
- 特定のバージョンのフロントエンド依存関係を標準化する（たとえば`sails generate jquery`）
- 新しいSailsアプリケーションに特定のフロントエンドフレームワークを含める
- 好きなテンプレートから新しいVue/ReactコンポーネントやAngularモジュールを簡単に組み込むことができます（例えば、`sails generate component`または`sails generate ng-module`）。

> カスタムジェネレータの作成に興味がある場合は、[カスタムジェネレータ入門](https://sailsguides.jp/doc/concepts/extending-sails/generators/custom-generators)をチェックするのが良いでしょう。。また、[コミュニティからオープンソースのジェネレータ](https://sailsguides.jp/doc/concepts/extending-sails/generators/available-generators)をチェックアウトすることもできます。すでに何かあれば、時間を節約できます。


<docmeta name="displayName" value="Generators">
<docmeta name="displayName_ja" value="ジェネレーター">
