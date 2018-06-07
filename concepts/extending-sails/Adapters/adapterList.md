# 利用可能なデータベースアダプタ

このページは、Sails.jsフレームワークで利用可能なコアアダプターの最新の一覧と、最も堅牢なコミュニティアダプターのリファレンスです。サポートされているすべてのアダプタは、Sails/Waterlineアダプタ（`adapter`）と接続URL（`url`）として渡すことによって、ほぼ同じ方法で設定できます。データストアの設定の詳細については、[sails.config.datastores](https://sailsguides.jp/doc/reference/configuration/sails-config-datastores)を見てください。

> 接続に問題がありますか？接続URLに入力ミスがないかどうか確認してください。それでも問題が解決しない場合は、データベースプロバイダのマニュアルを参照するか、[ヘルプを参照](https://sailsjs.com/support)してください。

### 公式にサポートしているデータベースアダプタ

以下のコアアダプターは、Sails.jsコアチームによって維持やテスト、そして使われています。

> コアアダプターを手伝いたいですか？[Sailsプロジェクトの貢献ガイド](https://sailsjs.com/contributing)を読んで始めましょう。

|  データベース    | アダプター                                                        | 接続URLの構造                      | 本番利用は大丈夫？     |
|:------------------------|:---------------------------------------------------------------|:----------------------------------------------|:--------------------|
|  MySQL                  | [require('sails-mysql')](http://npmjs.com/package/sails-mysql)            | `mysql://user:password@host:port/database`      | はい
|  PostgreSQL             | [require('sails-postgresql')](http://npmjs.com/package/sails-postgresql)  | `postgresql://user:password@host:port/database` | はい
|  MongoDB                | [require('sails-mongo')](http://npmjs.com/package/sails-mongo)            | `mongodb://user:password@host:port/database`      | はい
|  ローカルディスク/メモリー           | _（組み込み済み、[sails-disk](http://npmjs.com/package/sails-disk)を見てください）_          | _利用不可_                                         | **ダメです！**



### sails-mysql

[MySQL](http://en.wikipedia.org/wiki/MySQL)は世界で最も普及しているリレーショナルデータベースです。

[![NPM package info for sails-mysql](https://img.shields.io/npm/dm/sails-mysql.svg?style=plastic)](http://npmjs.com/package/sails-mysql) &nbsp; [![License info](https://img.shields.io/npm/l/sails-mysql.svg?style=plastic)](http://npmjs.com/package/sails-mysql)

```bash
npm install sails-mysql --save
```

```javascript
adapter: 'sails-mysql',
url: 'mysql://user:password@host:port/database',
```

> + MySQLのデフォルトポートは`3306`です。
> + データに絵文字などの特殊文字を保存する予定がある場合は、データストアの[`charset`](https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html)設定オプションを設定する必要があります。絵文字を許可するには、`charset: 'utf8mb4'`を使います。モデル属性で文字セットを設定するために、[`columnType` 設定](https://sailsguides.jp/doc/concepts/models-and-orm/attributes#?columntype)を使うかもしれません。
> + MySQLやPostgreSQLのようなリレーショナルデータベースサーバでは、まず最初に[SequelPro](https://www.sequelpro.com/)やmysqlのコマンドラインREPL（SQLの経験者の場合）を使って「データベース」を作成するとこから行うかもしれません。アプリケーションで使う専用のデータベースを作成するのが慣例です。
> + sails-mysqlアダプターは、[Amazon Aurora](https://aws.amazon.com/rds/aurora/)データベースと100％の互換性があります。


##### ハンドシェイクが非アクティブになることによる、タイムアウトエラー
SailsアプリケーションがMySQLと情報のやり取りをしているときに、「ハンドシェイクが非アクティブになりタイムアウトする」エラーが発生した場合は、`connectTimeout`オプションを使用してタイムアウトを増やすことができます。これは通常、クエリが高負荷な処理（たとえばクライアント側のtypescriptファイルのコンパイルや開発中のwebpackの実行）と並んで実行されている[場合にのみ必要](https://github.com/mysqljs/mysql/issues/1434)です。

例として、タイムアウトを20秒に延長することができます。

```javascript
adapter: 'sails-mysql',
url: 'mysql://user:password@host:port/database',
connectTimeout: 20000
```


### sails-postgresql

[PostgreSQL](http://en.wikipedia.org/wiki/postgresql)は強力な機能を備えた最新のリレーショナルデータベースです。

[![NPM package info for sails-postgresql](https://img.shields.io/npm/dm/sails-postgresql.svg?style=plastic)](http://npmjs.com/package/sails-postgresql) &nbsp; [![License info](https://img.shields.io/npm/l/sails-postgresql.svg?style=plastic)](http://npmjs.com/package/sails-postgresql)

```bash
npm install sails-postgresql --save
```

```javascript
adapter: 'sails-postgresql',
url: 'postgresql://user:password@host:port/database',
```

> + PostgreSQLのデフォルトのポートは`5432`です。
> + `adapter`と`url`に加えて、`ssl: true`も設定する必要があるかもしれません。（これは使用するPostgreSQLデータベースサーバがどこにほすとされているかによって変わります。例えば、HerokuでホストされているPostgreSQLサービスに接続する場合は、`ssl: true`が必要になります。）


### sails-mongo

[MongoDB](http://en.wikipedia.org/wiki/MongoDB)は主要なNoSQLデータベースです。

[![NPM package info for sails-mongo](https://img.shields.io/npm/dm/sails-mongo.svg?style=plastic)](http://npmjs.com/package/sails-mongo) &nbsp; [![License info](https://img.shields.io/npm/l/sails-mongo.svg?style=plastic)](http://npmjs.com/package/sails-mongo)

```bash
npm install sails-mongo --save
```

```javascript
adapter: 'sails-mongo',
url: 'mongodb://user:password@host:port/database',
```

> + MongoDBのデフォルトポートは`27017`です。
> + MongoDBのデプロイにおいて、内部の資格情報を別のデータベースに記録している場合、接続URLの末尾に[`?authSource=theotherdb`](https://stackoverflow.com/a/40608735/486547)のように名前を付加する必要があるかもしれません。



### sails-disk

コンピュータのハードディスクまたはマウントされたネットワークドライブに書き込みます。大規模な本番環境でのデプロイには適していませんが、小規模のプロジェクトには適しており、データベースをセットアップしていない環境での開発には不可欠です。このアダプタはSailsにバンドルされており、何も設定することなく、そのまま使用できます。

メモリオンリーモードでも`sails-disk`を使用できます。詳細については、下記の設定表を参照してください。

[![NPM package info for sails-disk](https://img.shields.io/npm/dm/sails-disk.svg?style=plastic)](http://npmjs.com/package/sails-disk) &nbsp; [![License info](https://img.shields.io/npm/l/sails-disk.svg?style=plastic)](http://npmjs.com/package/sails-disk)

_すべてのSailsアプリケーションで、何も設定することなく利用可能です。_

_デフォルトで、標準で使うデータベースとして設定されています。_

##### Optional datastore settings for `sails-disk`

| 設定 | 説明 | タイプ  | デフォルト |
|:--------|:------------|:------|:--------|
| `dir`   | 	データベースファイルを格納するディレクトリ。アダプタはモデルごとに1つのファイルを作成します。 | ((string)) | `.tmp/localDiskDb` |
| `inMemoryOnly` | `true`の場合、データベースファイルはディスクに書き込まれません。代わりに、すべてのデータがメモリに保存されます（アプリケーションが停止すると失われます）。 | ((boolean)) | `false` |

> + `config/datastores.js`の、`default`データストアにデフォルトの`sails-disk`アダプターを追加することで設定できます。


### コミュニティがサポートしている、データベースアダプタ

使いたいデータベースが、コアアダプタでサポートされていない？良いニュースがあります！Sails.jsとWaterlineには、[NPMで利用可能な](https://www.npmjs.com/search?q=sails+adapter)、多種多様なコミュニティデータベースアダプターがあります。

ここに主要なものを記します。


| データベース技術             | アダプター                | メンテナー | 実装されたインターフェース | リリースの安定性 |
|:--------------------------------|:-----------------------|:-----------|:-----------------------|-----------------------|
| **Redis**                       | [sails-redis](https://npmjs.com/package/sails-redis) | [Ryan Clough / Solnet Solutions](https://github.com/Ryanc1256) | セマンティック、クエリ可能                                               | [![NPM package info for sails-redis](https://img.shields.io/npm/dm/sails-redis.svg?style=plastic)](http://npmjs.com/package/sails-redis) |
| **MS SQL Server**               | [sails-MSSQLserver](https://github.com/misterGF/sails-mssqlserver) | [misterGF](https://github.com/misterGF) | セマンティック、クエリ可能                  | [![NPM package info for sails-sqlserver](https://img.shields.io/npm/dm/sails-sqlserver.svg?style=plastic)](http://npmjs.com/package/sails-sqlserver)
| **OrientDB**                    | [sails-orientDB](https://github.com/appscot/sails-orientdb) | [appscot](https://github.com/appscot) | セマンティック、クエリ可能、アソシエーション、マイグレーション可能 | [![NPM package info for sails-orientdb](https://img.shields.io/npm/dm/sails-orientdb.svg?style=plastic)](http://npmjs.com/package/sails-orientdb)
| **Oracle**                      | [sails-oracleDB](https://npmjs.com/package/sails-oracledb) | [atiertant](https://github.com/atiertant) | セマンティック、クエリ可能 | [![NPM package info for sails-oracledb](https://img.shields.io/npm/dm/sails-oracledb.svg?style=plastic)](http://npmjs.com/package/sails-oracledb) |
| **Oracle (AnyPresence)**        | [waterline-oracle-adapter](https://github.com/AnyPresence/waterline-oracle-adapter) | [AnyPresence](http://anypresence.com) | セマンティック、クエリ可能     | [![Release info for AnyPresence/waterline-oracle-adapter](https://img.shields.io/github/tag/AnyPresence/waterline-oracle-adapter.svg?style=plastic)](https://github.com/AnyPresence/waterline-oracle-adapter)
| **Oracle (stored procedures)**  | [sails-oracle-SP](https://npmjs.com/sails-oracle-sp) | [Buto](http://github.com/buto) and [nethoncho](http://github.com/nethoncho) | セマンティック、クエリ可能     | [![NPM package info for sails-oracle-sp](https://img.shields.io/npm/dm/sails-oracle-sp.svg?style=plastic)](http://npmjs.com/package/sails-oracle-sp)
| **SAP HANA DB**                 | [sails-HANA](https://npmjs.com/sails-hana) | [Digital Rockers](http://www.digitalrockers.it/) &amp; [Enrico Battistella](http://github.com/battishaar) | セマンティック、クエリ可能     | [![NPM package info for sails-hana](https://img.shields.io/npm/dm/sails-hana.svg?style=plastic)](http://npmjs.com/package/sails-hana)
| **SAP HANA (AnyPresence)**      | [waterline-SAP-HANA-adapter](https://github.com/AnyPresence/waterline-sap-hana-adapter) | [AnyPresence](http://anypresence.com) | セマンティック、クエリ可能     | [![Release info for AnyPresence/waterline-sap-hana-adapter](https://img.shields.io/github/tag/AnyPresence/waterline-sap-hana-adapter.svg?style=plastic)](https://github.com/AnyPresence/waterline-sap-hana-adapter)
| **IBM DB2**                     | [sails-DB2](https://npmjs.com/sails-db2) | [ibuildings Italia](https://github.com/IbuildingsItaly) &amp; [Vincenzo Ferrari](https://github.com/wilk) | セマンティック、クエリ可能    | [![NPM package info for sails-db2](https://img.shields.io/npm/dm/sails-db2.svg?style=plastic)](http://npmjs.com/package/sails-db2)
| **ServiceNow SOAP**             | [waterline-ServiceNow-SOAP](https://npmjs.com/waterline-servicenow-soap) | [Sungard Availability Services](http://www.sungardas.com/) | セマンティック、クエリ可能     | [![NPM package info for waterline-servicenow-soap](https://img.shields.io/npm/dm/waterline-servicenow-soap.svg?style=plastic)](http://npmjs.com/package/waterline-servicenow-soap)
| **Cassandra**                   | [sails-cassandra](https://github.com/dtoubelis/sails-cassandra) | [dtoubelis](https://github.com/dtoubelis) | セマンティック、マイグレーション可能、イテラブル | [![NPM package info for sails-cassandra](https://img.shields.io/npm/dm/sails-cassandra.svg?style=plastic)](http://npmjs.com/package/sails-cassandra)
| **Solr**                        | [sails-solr](https://github.com/sajov/sails-solr) | [sajov](https://github.com/sajov) | セマンティック、マイグレーション可能、イテラブル | [![NPM package info for sails-solr](https://img.shields.io/npm/dm/sails-solr.svg?style=plastic)](http://npmjs.com/package/sails-solr)
| **FileMaker Database**          | [sails-FileMaker](https://github.com/geistinteractive/sails-filemaker) | [Geist Interactive](https://www.geistinteractive.com/) | セマンティック | [![NPM package info for sails-filemaker](https://img.shields.io/npm/dm/sails-filemaker.svg?style=plastic)](http://npmjs.com/package/sails-filemaker)
| **Apache Derby**                | [sails-derby](https://github.com/dash-/node-sails-derby) | [dash-](https://github.com/dash-) | セマンティック、クエリ可能、アソシエーション、SQL | [![NPM package info for sails-derby](https://img.shields.io/npm/dm/sails-derby.svg?style=plastic)](http://npmjs.com/package/sails-derby)
| **REST API (Generic)**          | [sails-REST](https://github.com/zohararad/sails-rest) | [zohararad](https://github.com/zohararad) | セマンティック                                        | [![NPM package info for sails-rest](https://img.shields.io/npm/dm/sails-rest.svg?style=plastic)](http://npmjs.com/package/sails-rest)



##### 自分のカスタムアダプターをこのリストに追加する

このページの古い情報が表示された場合や作成したアダプターを追加する場合は、上記のコミュニティアダプターのテーブルを更新してプルリクエストを送信してください。

このページに記載されているアダプタは、次の条件を満たす必要があります。

1. フリーでオープンソース（libre and gratis）として公開してください。MITライセンスが望ましいです。
2. package.jsonで宣言されているインターフェースレイヤー向けの、すべてのWaterlineのアダプターテストに合格してください。
3. `url`として接続URLの設定をサポートしてください（該当する場合）。

上記のコミュニティアダプターにこれらの規約のいずれかが当てはまらないことが判明した場合（言い換えると、Githubのコードではなく、NPMへ公開された最新の安定板）、アダプターのメンテナに問い合わせてください。連絡が取れない場合や、さらなる支援が必要な場合は、Sailsのコアチームのメンバーに[連絡](https://sailsjs.com/contact)してください。



<docmeta name="displayName" value="利用可能なアダプター">
