# アダプター

### アダプターとは？

SailsとWaterlineでは、データベースアダプター（「アダプター」とも呼ばれます）は、Sailsアプリケーションのモデルがデータベースと通信できるようにします。言い換えれば、コントローラアクションまたはヘルパーのコードが`User.find()`のようなモデルメソッドを呼び出すと、実行されるのは[設定されたアダプター](https://sailsjs.com/documentation/reference/configuration/sails-config-datastores)によって決まります。

アダプターは、`find`や`create`などのメソッドを持つ辞書（Javasctipのオブジェクト、`{}`のようなものです）として定義されます。実装しているメソッドやその完全性に基づいて、アダプターは一つ以上の**インターフェースレイヤ**を実装するのが良いといわれています。各インターフェイスレイヤは、ある機能を実装するための約定を意味します。これにより、SailsとWaterlineは、複数のモデルや開発者やアプリ、さらには企業まで、従来のパターン化された使用方法を保証し、アプリケーションコードのメンテナンス性や効率性、信頼性を向上させます。

> Sailsの以前のバージョンでは、ある種のRESTful Web APIや内部/独自Webサービス、またはハードウェアとの通信など、他の目的でアダプターが使用されることがありました。しかし、本当にRESTfulなAPIは非常にまれであるため、たいていの場合、データベースではないAPIとの統合のためにデータベース・アダプターを作成することは制限されるているかもしれません。幸いにも、こういった統合を構築するための[より素直な方法](https://sailsjs.com/documentation/concepts/helpers)があります。

### アダプターではどんなことができますか？

アダプターは、主に、モデル・コンテキスト化されたCRUDメソッドを提供することに重点を置いています。CRUDは、作成、読み取り、更新、および削除を表します。Sails/Waterlineでは、`create()`や`find()`や`update()`、そして`destroy()`というメソッドを呼び出します。

例えば、`MySQLAdapter`は`create()`という、MySQLデータベースを指定されたテーブル名とコネクション情報で呼び出し、`INSERT ...`というSQLクエリを内部的に実行するようなメソッドを実装しています。


### 次のステップ

[有効なアダプター](https://sailsjs.com/documentation/concepts/extending-sails/adapters/available-adapters)を読むか、[カスタムアダプター](https://sailsjs.com/documentation/concepts/extending-sails/adapters/custom-adapters)を作成する方法を読みます。

<docmeta name="displayName" value="アダプター">
<docmeta name="stabilityIndex" value="3">
