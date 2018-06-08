# アセット

### 概要

アセットとは、サーバー上の[静的なファイル](http://en.wikipedia.org/wiki/Static_web_page)（js、css、画像など）を指し、外部のユーザーがアクセスできるようにしたいものです。Sailsでは、これらのファイルは[`assets/`](https://sailsguides.jp/doc/anatomy/assets)フォルダーに置かれます。アプリをliftすると、`assets/`フォルダへファイルを追加したり既存のアセットを変更した場合に、Sailsは組み込みのアセットパイプラインが実行され、`.tmp/public/`という隠しフォルダへファイルを同期させます。

> この`assets/`から`.tmp/public/`へファイルを移動させるという中間ステップは、クライアント上で使用するためのファイル（LESS、CoffeeScript、SASS、spritesheets、Jadeテンプレートなど）をSailsが前処理することを可能にします。

この`.tmp/public`フォルダの内容は、Sailsが実際に実行時に提供するものです。これは、[express](https://github.com/expressjs)の"public"フォルダ、またはApacheのようなウェブサーバーで慣れ親しんだ`www/`フォルダとほぼ同じです。


### 静的ミドルウェア

水面下では、Expressからの[serve-static middleware](https://www.npmjs.com/package/serve-static)を使ってアセットを提供します。[`/config/http.js`](https://sailsguides.jp/doc/reference/configuration/sails-config-http)ファイルで、このミドルウェアを設定することができます（例として、キャッシュ設定を変更するなど）。

##### `index.html`

ほとんどのWebサーバーと同様に、Sailsは`index.html`規約を尊重します。たとえば、もし新しいSailsプロジェクトで`assets/foo.html`を作成したら、`http://localhost:1337/foo.html`からアクセスできるようになります。もし`assets/foo/index.html`を作成した場合、`http://localhost:1337/foo/index.html`か`http://localhost:1337/foo`のどちらでもアクセスできます。

##### 優先

静的[ミドルウェア](http://stephensugden.com/middleware_guide/)は、Sailsルーターの**後に**インストールされることが重要です。したがって、[カスタムルート](https://sailsguides.jp/doc/concepts/Routes?q=custom-routes)を定義し、競合するパスを持つファイルがアセットディレクトリにある場合、カスタムルートは静的ミドルウェアに到達する前にリクエストを横取りします。たとえば、`assets/index.html`を作成し、[`config/routes.js`](https://sailsguides.jp/doc/reference/configuration/sails-config-routes)ファイルに何もルート定義がない場合、ホームページとして提供されます。しかし、`'/': 'FooController.bar'`というカスタムルートを定義した場合、そのルートが優先されます。


<docmeta name="displayName" value="Assets">
<docmeta name="displayName_ja" value="アセット">
<docmeta name="nextUpLink" value="/documentation/concepts/shell-scripts">
<docmeta name="nextUpName" value="Shell Scripts">
