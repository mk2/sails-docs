# 利用可能なジェネレーター

Sailsフレームワークの組み込みの[ジェネレーター](https://sailsguides.jp/doc/concepts/extending-sails/generators)は、コマンドラインオプションを使用してカスタマイズすることができ、[カスタムジェネレータを`.sailsrc`ファイルにマウントする](https://sailsguides.jp/doc/concepts/extending-sails/generators/custom-generators)ことで上書きできます。[`sails generate`](https://sailsguides.jp/doc/reference/command-line-interface/sails-generate)に完全に新しいサブコマンドを追加する他のジェネレータも同じ方法でマウントできます。

### コアジェネレーター

特定のジェネレーターは、Sailsにデフォルトで組み込まれています。

| 新しいSailsアプリケーションを生成するコマンド
|:-----------------------------------|
| sails new _name_
| sails new _name_ --fast
| sails new _name_ --caviar
| sails new _name_ --without=grunt
| sails new _name_ --without=lodash,async,grunt,blueprints,i18n
| sails new _name_ --no-frontend --without=sockets,lodash
| sails new _name_ --minimal


| Sailsアプリケーションで、新しいファイルを生成するためのジェネレーター
|:-----------------------------------|
| sails generate model _identity_
| sails generate action _name_
| sails generate action view-_name_
| sails generate action _some/path/_view-_name_
| sails generate page _name_
| sails generate helper _name_
| sails generate helper view-_name_
| sails generate script _name_
| sails generate script get-_name_
| sails generate controller _name_
| sails generate api _name_
| sails generate hook _name_
| sails generate response _name_


| プラグインを生成するためのコマンド |
|:-----------------------------------|
| sails generate generator _name_
| sails generate adapter _name_


| クライアント側の依存関係を生成（もしくは再生成）するためのコマンド
|:-----------------------------------|
| sails generate sails.io.js
| sails generate parasails

| サードパーティパッケージを構築するためのユーティティ
|:-----------------------------------|
| sails generate etc


_Sailsのv1.0以降、組み込みのジェネレーターは、別のNPMパッケージではなく、Sailsコアに[バンドルされています](https://npmjs.com/package/sails-generate)。すべてのジェネレーターは同じ方法で上書きすることができます。コアジェネレーターで上書きを設定する方法については、[サポートに問い合わせてください](https://sailsjs.com/support)。_


### コミュニティのジェネレーター

100を超えるコミュニティサポートのジェネレーターが、[NPMで利用可能です](https://www.npmjs.com/search?q=sails+generate)。

+ [sails-inverse-model](https://github.com/juliandavidmr/sails-inverse-model)
+ [sails-generate-new-gulp](https://github.com/Karnith/sails-generate-new-gulp)
+ [sails-generate-archive](https://github.com/jaumard/sails-generate-archive)
+ [sails-generate-scaffold](https://github.com/irlnathan/sails-generate-scaffold)
+ [sails-generate-directive](https://github.com/balderdashy/sails-generate-directive)
+ [sails-generate-bower](https://github.com/smies/sails-generate-bower)
+ [sails-generate-angular-gulp](https://github.com/Karnith/sails-generate-angular-gulp)
+ [sails-generate-ember-blueprints](https://github.com/mphasize/sails-generate-ember-blueprints)
+ 他にも、[たくさんあります](https://www.npmjs.com/search?q=sails+generate)。


<docmeta name="displayName" value="Available generators">
<docmeta name="displayName_ja" value="利用可能なジェネレーター">
