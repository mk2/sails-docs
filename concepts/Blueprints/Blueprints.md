# Blueprints

### 概要

他の優れたWebフレームワークと同様に、Sailsは、書くコードの量と機能的なアプリケーションを起動して実行するのにかかる時間の両方を削減することを目指しています。 Blueprintsは、アプリケーション設計に基づいてAPI[ルート](https://sailsguides.jp/doc/concepts/routes)と[アクション](https://sailsguides.jp/doc/concepts/controllers#?actions)を迅速に生成するSailsの方法です。

[blueprintルート](https://sailsguides.jp/doc/concepts/blueprints/blueprint-routes)と[blueprintアクション](https://sailsguides.jp/doc/concepts/blueprints/blueprint-actions)は一緒に**blueprint API**を構成し、組み込みのロジックは[RESTful JSON API](http://en.wikipedia.org/wiki/Representational_state_transfer)を強化し、モデルとコントローラーを作成するたびにその恩恵を受けることができます。

例えば、プロジェクトに`User.js`モデルファイルを作成したとき、blueprintがあれば、`/user/create?name=joe`をリクエストするとユーザーを作成したり、`/user`をリクエストするとアプリのユーザーを配列としてみることができる、というようなことをすばやく有効化することができます。1行のコードも書くことなく！

Blueprintは強力なプロトタイピングツールですが、上書きしたり保護したり拡張したり、完全に無効化できるため、本番環境でも多くの場合同様に使用できます。

### 次に

+ 組み込みのblueprintアクションについて[詳細を読む](https://sailsguides.jp/doc/concepts/blueprints/blueprint-actions)。
+ 暗黙の「シャドウ」ルートについて、それをどのように設定したり上書きしたりするのか、[詳細を読む](https://sailsguides.jp/doc/concepts/blueprints/blueprint-routes)。

<docmeta name="displayName" value="Blueprints">
