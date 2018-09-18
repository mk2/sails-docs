# プロジェクトフックの作成

プロジェクトフックは、アプリケーションの`api/hooks`フォルダにあるカスタムセイルフックです。単一のアプリケーションで複数のコンポーネントが使用するコードで、[デフォルト](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/defaults)や[ルート](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/routes)などのフック機能を利用する場合に便利です。複数のSailsアプリでフックを再利用したい場合は、代わりに[インストール可能なフックの作成](https://sailsguides.jp/doc/concepts/extending-sails/hooks/installable-hooks)を参照してください。

新しくプロジェクトフックを作成する方法です。

1. 新しいフックの名前を選択します。[コアのフック名](https://github.com/balderdashy/sails/blob/master/lib/app/configuration/default-hooks.js)と衝突してはいけません。
2. その名前のフォルダをアプリケーションの`api/hooks`フォルダに作成します。
3. そのフォルダに`index.js`ファイルを追加します。
4. [フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)に従ってフックのコードを`index.js`に記述してください。

新しいフォルダには他のファイルも含まれているかもしれませんが、それらはフック内で`require`を使うことで読み込むことができます。Sailsが自動で読み込むのは、`index.js`のみです。

フォルダの代わりに、`api/hooks`フォルダに`api/hooks/myProjectHook.js`のようなファイルを作成することもできます。

#### 適切にフックが読み込まれていることをテストする

フックがSailsによって読み込まれていることをテストするには、`sails lift --verbose`でアプリケーションを立ち上げます。フックが読み込まれているのであれば、次のようなメッセージがログに表示されます。

`verbose: your-hook-name hook loaded successfully.`

* [フックの概要](https://sailsguides.jp/doc/concepts/extending-sails/hooks)
* [アプリケーションでフックを使う](https://sailsguides.jp/doc/concepts/extending-sails/hooks/using-hooks)
* [フックの仕様](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification)
* [インストール可能なフックを作成する](https://sailsguides.jp/doc/concepts/extending-sails/hooks/installable-hooks)


<docmeta name="displayName" value="Project hooks">
<docmeta name="displayName_ja" value="プロジェクトフック">
<docmeta name="stabilityIndex" value="3">
