# 利用可能なフック


このページでは、Sails.jsフレームワークの中核となるすべてのフックの最新のリストや、最も人気のあるコミュニティ製のフックを紹介しています。

### コアフック

以下のフックはSails.jsコアチームによって管理され、デフォルトでSailsアプリに含まれています。[sailsrcファイル](https://sailsguides.jp/doc/concepts/configuration/using-sailsrc-files)または[環境変数](https://sailsguides.jp/docu/concepts/configuration#?setting-sailsconfig-values-directly-using-environment-variables)を使用して、それらを無効または無効にすることができます。


| フック           | パッケージ       | 最新の安定板   | 目的     |
|:---------------|---------------|-------------------------|:------------|
| `grunt`        | [sails-hook-grunt](https://npmjs.com/package/sails-hook-grunt)      | [![NPM version](https://badge.fury.io/js/sails-hook-grunt.png)](http://badge.fury.io/js/sails-hook-grunt)     | Sailsの組み込みアセットパイプラインを管理します。
| `orm`          | [sails-hook-orm](https://npmjs.com/package/sails-hook-orm)          | [![NPM version](https://badge.fury.io/js/sails-hook-orm.png)](http://badge.fury.io/js/sails-hook-orm)         | SailsのWaterline ORMをサポートします。
| `sockets`      | [sails-hook-sockets](https://npmjs.com/package/sails-hook-sockets)  | [![NPM version](https://badge.fury.io/js/sails-hook-sockets.png)](http://badge.fury.io/js/sails-hook-sockets) | SailsのSocket.ioをサポートします。

### sails-hook-orm

SailsのWaterline ORMサポートを提供します。

[![Release info for sails-hook-orm](https://img.shields.io/npm/dm/sails-hook-orm.svg?style=plastic)](http://npmjs.com/package/sails-hook-orm) &nbsp; [![License info](https://img.shields.io/npm/l/sails-hook-orm.svg?style=plastic)](http://npmjs.com/package/sails-hook-orm)

> + このフックで設定されているデフォルト設定は、[ここ](https://www.npmjs.com/package/sails-hook-orm#implicit-defaults)にあります。
> + このフックの目的についてのさらなる詳細は[ここ](https://www.npmjs.com/package/sails-hook-orm#purpose)にあります。
> + [この指示](https://www.npmjs.com/package/sails-hook-orm#can-i-disable-this-hook)に従えば、このフックを無効化することができます。

### sails-hook-sockets

Sailsのsocket.ioサポートを提供します。

[![Release info for sails-hook-sockets](https://img.shields.io/npm/dm/sails-hook-sockets.svg?style=plastic)](http://npmjs.com/package/sails-hook-sockets) &nbsp; [![License info](https://img.shields.io/npm/l/sails-hook-sockets.svg?style=plastic)](http://npmjs.com/package/sails-hook-sockets)

> + このフックの目的についてのさらなる詳細は[ここ](https://www.npmjs.com/package/sails-hook-sockets#purpose)にあります。

### sails-hook-grunt

Sailsの組み込みアセットパイプラインとタスクランナーのサポートを提供します。

[![Release info for sails-hook-grunt](https://img.shields.io/npm/dm/sails-hook-grunt.svg?style=plastic)](http://npmjs.com/package/sails-hook-grunt) &nbsp; [![License info](https://img.shields.io/npm/l/sails-hook-grunt.svg?style=plastic)](http://npmjs.com/package/sails-hook-grunt)

> + このフックの目的についてのさらなる詳細は[ここ](https://www.npmjs.com/package/sails-hook-grunt#purpose)にあります。
> + [この指示](https://www.npmjs.com/package/sails-hook-grunt#can-i-disable-this-hook)に従えば、このフックを無効化することができます。


### コミュニティ製のフック

[NPMにはSails.jsのコミュニティフックが200以上](https://www.npmjs.com/search?q=sails+hook)あります。ここでいくつかピックアップします。

| フック        | メンテナ  | 目的        | 安定板 |
|-------------|-------------|:---------------|----------------|
| [sails-hook-webpack](https://www.npmjs.com/package/sails-hook-webpack) | [Michael Diarmid](https://github.com/Salakar) &amp; [Team FA](http://teamfa.com/)| Gruntの代わりにWebpackをアセットパイプラインで使用できます。 | [![Release info for sails-hook-webpack](https://img.shields.io/npm/dm/sails-hook-webpack.svg?style=plastic)](http://npmjs.com/package/sails-hook-webpack)
| [sails-hook-postcss](https://www.npmjs.com/package/sails-hook-postcss) | [Jeff Jewiss](https://github.com/jeffjewiss)| SailsアプリケーションのCSSをPostcssで処理します。 | [![Release info for sails-hook-postcss](https://img.shields.io/npm/dm/sails-hook-postcss.svg?style=plastic)](http://npmjs.com/package/sails-hook-postcss)
| [sails-hook-babel](https://www.npmjs.com/package/sails-hook-babel) |  [Onoshko Dan](https://github.com/dangreen), [Markus Padourek](https://github.com/globegitter) &amp; [SANE](http://sanestack.com/) | SailsアプリケーションのCSSをPostcssで処理します。 | [![Release info for sails-hook-babel](https://img.shields.io/npm/dm/sails-hook-babel.svg?style=plastic)](http://npmjs.com/package/sails-hook-babel)
| [sails-hook-responsetime](https://www.npmjs.com/package/sails-hook-responsetime) | [Luis Lobo Borobia](https://github.com/luislobo)| HTTPレスポンスとソケットリクエストヘッダーの両方にX-Response-Timeを追加します。 | [![Release info for sails-hook-responsetime](https://img.shields.io/npm/dm/sails-hook-responsetime.svg?style=plastic)](http://npmjs.com/package/sails-hook-responsetime)
| [sails-hook-winston](https://www.npmjs.com/package/sails-hook-winston) | [Kikobeats](https://github.com/Kikobeats) | WinstonロギングシステムとSailsアプリケーションを統合します。 | [![Release info for sails-hook-winston](https://img.shields.io/npm/dm/sails-hook-winston.svg?style=plastic)](http://npmjs.com/package/sails-hook-winston)
| [sails-hook-allowed-hosts](https://www.npmjs.com/package/sails-hook-allowed-hosts) | [Akshay Bist](https://github.com/elssar) | 許可されたホスト/IPアドレスからの要求のみが許可されていることを確認します。 | [![Release info for sails-hook-allowed-hosts](https://img.shields.io/npm/dm/sails-hook-allowed-hosts.svg?style=plastic)](http://npmjs.com/package/sails-hook-allowed-hosts)
| [sails-hook-cron](https://www.npmjs.com/package/sails-hook-cron) | [Eugene Obrezkov](https://github.com/ghaiklor) | Sailsアプリケーションのcronタスクを実行します。 | [![Release info for sails-hook-cron](https://img.shields.io/npm/dm/sails-hook-cron.svg?style=plastic)](http://npmjs.com/package/sails-hook-cron)


##### このリストにフックを追加する

このページに古い情報が表示されている場合や、作成したフックを追加したい場合は、上記のコミュニティフックのテーブルを更新して、このファイルのプルリクエストを送信してください。


このページに記載されているように、アダプターは無料でオープンソース（無償、無償）であることが必要です。


<docmeta name="displayName" value="Available hooks">
<docmeta name="displayName_ja" value="利用可能なフック">
