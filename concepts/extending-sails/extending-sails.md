# Sailsを拡張する

Nodeの考え方に沿って、Sailsはコアを可能な限り小さく保つことを目指し、最も重要な機能以外のすべてを分離したモジュール[*](./#foot1)へ委譲しています。現在、Sailsにできる拡張機能には3種類あります。

+ [**ジェネレーター**](https://sailsjs.com/documentation/concepts/extending-sails/generators) - Sails CLIに対して、機能を追加および上書きします。*例*：[sails-generate-model](https://www.npmjs.com/package/sails-generate-model)は、`sails generate model foo`というコマンドでモデルを作れるようにしてくれます。
+ [**アダプター**](https://sailsjs.com/documentation/concepts/extending-sails/adapters) - Waterline（SailsのORM）と、データベースやAPI、またはハードウェアなどの新しいデータソースを統合するためのものです。*例*：[sails-postgresql](https://www.npmjs.com/package/sails-postgresql)は、Sailsの公式な[PostgreSQL](http://www.postgresql.org/)向けのアダプターです。
+ [**フック**](https://sailsjs.com/documentation/concepts/extending-sails/hooks) - Sails実行時に新しい機能を上書きしたり注入したりするためのものです。*例*：[sails-hook-autoreload](https://www.npmjs.com/package/sails-hook-autoreload)は、SailsプロジェクトのAPIの自動リフレッシュ機能を追加します。手動でサーバーを再起動する必要はありません。

Sails用のプラグインを開発することに興味があるなら、ほとんどの場合、[hook](https://sailsjs.com/documentation/concepts/extending-sails/hooks)を作りたいと思うでしょう。


<sub><a name="foot1">*</a> コア・フック、例えばhttp、requestなどは、Sailsにあらかじめバンドルされているフックです。`.sailsrc`ファイルに`hooks`設定を指定するか、プログラムでSailsを起動することで無効化できます。</sub>

<docmeta name="displayName" value="Extending Sails">
<docmeta name="displayName_ja" value="Sailsを拡張する">
