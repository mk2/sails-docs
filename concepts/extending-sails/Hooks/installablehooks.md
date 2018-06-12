# インストール可能なフックの作成
インストール可能なフックは、アプリケーションの`node_modules`フォルダにあるカスタムなSailsフックです。Sailsアプリケーション間で機能を共有したり、[NPM](http://npmjs.org)にフックを公開してSailsコミュニティと共有したりする場合に便利です。1つの Sailsアプリケーションで使用するフックを作成する場合は 、代わりに[プロジェクトフックの作成](https://sailsguides.jp/doc/concepts/extending-sails/hooks/project-hooks)を参照してください。

新規のインストール可能なフックを作成する方法を説明します。

1. 新しいフックの名前を選択します。[コアフックの名前](https://github.com/balderdashy/sails/blob/master/lib/app/configuration/default-hooks.js)と衝突してはいけません。
2. `sails-hook-<your hook name>`という名前でシステムに新しいフォルダを作成します。`sails-hook-`接頭辞はオプションですが、一貫性のために推奨されています。フックがロードされた時に、Sailsによって接頭辞は取り除かれます。
3. `package.json`ファイルをフォルダに作成します。`npm`がシステムにインストールされている場合は、`npm init`を実行し、指示に従うことで簡単に実行できます。それ以外の場合は、手動でファイルを作成し、ファイルに次の記述が最低限含まれていることを確認します。

```json
{
    "name": "sails-hook-your-hook-name",
    "version": "0.0.0",
    "description": "a brief description of your hook",
    "main": "index.js",
    "sails": {
      "isHook": true
    }
}
```

もし`npm init`を使って`package.json`を作成したら、後でファイルを開いて、`isHook: true`を含む`sails`キーを手作業で挿入してください。

1. [フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)に従って、`index.js`にフックのコードを書いてください。

新しいフォルダには他のファイルも含まれている可能性があります。それらは`require`によってフックでロードすることができ、`index.js`のみがSailsによって自動的に読み込まれます。`package.json`の`dependencies`キーを使うことで、フックを動かすために必要なすべての依存関係を参照することができます。（さらには`npm install <dependency> --save`を使うことで、簡単に`package.json`に依存関係の情報を保存することもできます。）


### フックに対してSailsが内部で使う名前を指定する（上級）

時に、Sailsのコアフックを上書きする[スコープ付きNPMパッケージ](https://docs.npmjs.com/misc/scope)を使う時、Sailsがフックをロードするときに内部的に使用する名前を変更したい場合があります。そのために、`package.json`ファイルにある`sails.hookName`設定オプションを使うことができます。その値は`sails.hooks`の下にロードさせたい名前にすべきで、一般的に`sails-hooks-`接頭辞をつけたくないでしょう。例えば、`@mycoolhooks/sails-hook-sockets`モジュールがあった場合に、コアの`sails-hooks-sockets`モジュールを上書きしたいとします。その場合、`package.json`は次のようになるでしょう。

```json
{
    "name": "@mycoolhooks/sails-hook-sockets",
    "version": "0.0.0",
    "description": "my own sockets hook",
    "main": "index.js",
    "sails": {
      "isHook": true,
      "hookName": "sockets"
    }
}
```

### 新しいフックのテスト

インストール可能なフックを他の人へ配布する前に、いくつかのテストを書いておきましょう。これにより、将来のSailsバージョンとの互換性が確保され、毛をかきむしりたくなるような、もしくは怒りに満ちた近くのオブジェクトの破壊が大幅に軽減されます。テストを書くための完全なガイドはこのドキュメントの範囲外ですが、以下の手順で始めてください。

1. フックの`package.json`で、Sailsを`devDependency`に追加します。

```json
"devDependencies": {
      "sails": "~0.11.0"
}
```

2. `npm install sails`や`npm link sails`を実行してSailsをフックの依存関係としてインストールします（もしSailsがグローバルにインストールされている場合）
3. まだMochaをインストールしていない場合は、`npm install -g mocha`を実行して[Mocha](http://mochajs.org/)をシステムにインストールします。
4. `test`フォルダーをフックのメインフォルダへ追加します。
5. `basic.js`ファイルを作成し、次のような基本的なテストを記入します。

```javascript
    var Sails = require('sails').Sails;

    describe('Basic tests ::', function() {

        // Var to hold a running sails app instance
        var sails;

        // Before running any tests, attempt to lift Sails
        before(function (done) {

            // Hook will timeout in 10 seconds
            this.timeout(11000);

            // Attempt to lift sails
            Sails().lift({
              hooks: {
                // Load the hook
                "your-hook-name": require('../'),
                // Skip grunt (unless your hook uses it)
                "grunt": false
              },
              log: {level: "error"}
            },function (err, _sails) {
              if (err) return done(err);
              sails = _sails;
              return done();
            });
        });

        // After tests are complete, lower Sails
        after(function (done) {

            // Lower Sails (if it successfully lifted)
            if (sails) {
                return sails.lower(done);
            }
            // Otherwise just return
            return done();
        });

        // Test that Sails can lift with the hook in place
        it ('sails does not crash', function() {
            return true;
        });

    });
```

6. `mocha -R spec`でテストを実行し、全結果が表示されます。
7. 詳細は[Mocha](http://mochajs.org/)のドキュメントを見てください。


### フックを公開する

フックがテストされ、いい感じになったら、さらにフック名がまだ[NPM](http://npmjs.org)の他のモジュールで使われていないのなら`npm publish`を実行して世界に共有できます！やってみましょう！


* [フックの概要](https://sailsguides.jp/doc/concepts/extending-sails/hooks)
* [アプリケーションでフックを使う](https://sailsguides.jp/doc/concepts/extending-sails/hooks/using-hooks)
* [フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)
* [プロジェクトのフックを作成する](https://sailsguides.jp/doc/concepts/extending-sails/hooks/project-hooks)



<docmeta name="displayName" value="Installable hooks">
<docmeta name="displayName_ja" value="インストール可能なフック">
<docmeta name="stabilityIndex" value="3">
