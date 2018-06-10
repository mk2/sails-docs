# フック

### フックとは何ですか？

フックは、Sailsコアに機能を追加するNodeモジュールです。[フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)では、Sailsがそのコードをインポートし、新しい機能を利用できるようにするためのモジュールが満たすべき要件を定義しています。コアとは別に保存することができるため、フックを使用すると、フレームワークを変更することなくアプリケーションと開発者がSailsコードを共有することができます。

### フックの種類

Sailsには3種類のフックがあります。

1. **コアフック**。これはあらかじめ組み込まれているフックで、リクエスト処理、blueprintルート作成、そして[Waterline](https://sailsguides.jp/doc/concepts/models-and-orm)経由でのデータベース統合など、Sailsアプリケーションに不可欠な多くの共通機能を提供します。コアフックはSailsコアにバンドルされており、すべてのアプリで使用できます。コード内でコアフックメソッドを呼び出す必要はほとんどありません。
2. **アプリケーションレベルのフック**。これらは、Sailsアプリケーションの`api/hooks`フォルダににあるフックです。プロジェクトのフックは、アプリケーション間で共有する必要のないコードでフックシステムの機能を利用する方法を提供します。
3. **インストール可能なフック**。これらのフックはプラグインであり、`npm install`を使用することでアプリケーションの`node_modules`フォルダにインストールされます。インストール可能なフックを用いることで、Sailsコミュニティの開発者はSailsアプリケーションで使用するための「プラグイン」のようなモジュールを作成することができます。

### 続きを読む

* [アプリケーションでフックを使う](https://sailsguides.jp/doc/concepts/extending-sails/hooks/using-hooks)
* [フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)
* [プロジェクトのフックを作成する](https://sailsguides.jp/doc/concepts/extending-sails/hooks/project-hooks)
* [インストール可能なフックを作成する](https://sailsguides.jp/doc/concepts/extending-sails/Hooks/installable-hooks)



<docmeta name="displayName" value="Hooks">
<docmeta name="displayName_ja" value="フック">
<docmeta name="stabilityIndex" value="3">
