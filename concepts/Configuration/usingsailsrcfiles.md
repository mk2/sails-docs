# .sailsrcファイルを使う

アプリを設定する他の方法に加えて、`.sailsrc`ファイルで複数のアプリの設定を行うこともできます。このファイルは、Sailsのコマンドライン、特にジェネレータの設定に役立ちます。また、必要に応じて、コンピュータ上で実行するSailsアプリケーションにジェネレータの _グローバル_ な構成設定を適用することもできます。

Sails CLIがコマンドを実行すると、現在のディレクトリとホームフォルダ（いいかえると`~/.sailsrc`、新しく生成されたすべてのSailsアプリケーションには定型の`.sailsrc`ファイルが付属しています）の`.sailsrc`ファイル（JSON 形式または[.ini](https://ja.wikipedia.org/wiki/INI%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)形式のファイル）が最初に検索され ます。次に、それらを既存の構成にマージします。

> 実際には、Sailsはいくつかの場所で`.sailsrc`ファイルを探します（[rcの規約](https://github.com/dominictarr/rc#standards)に従って）。すべてのSailsアプリケーションにグローバルに適用するには、これらのパスのいずれかに`.sailsrc`ファイルを置くことができます。つまり、グローバルな`.sailsrc`ファイルを置くのに最適な場所はホームディレクトリ（すなわち、ホームディレクトリ`~/.sailsrc`）です。




<docmeta name="displayName" value="Using `.sailsrc` files">
<docmeta name="displayName_ja" value=".sailsrcファイルを使う">
