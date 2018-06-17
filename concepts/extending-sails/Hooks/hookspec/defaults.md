# `.defaults`

`defaults`機能は、オブジェクト、または単一の引数（後述の「`defaults`関数としての使用」を参照）を受け取りオブジェクトを返す関数、として実装できます。オブジェクトとして実装した場合は、Sailsのデフォルトの設定値を設定するために使用されます。この機能を使用して、フックのデフォルト設定を指定する必要があります。たとえば、リモートサービスと通信するフックを作成する場合は、デフォルトのドメインとタイムアウトの長さを指定することができます。


```
{
   myapihook: {
      timeout: 5000,
      domain: "www.myapi.com"
   }
}
```

`myapihook.timeout`の値がSailsの設定ファイルを介して設定された場合、その値が使用されます。それ以外の場合はデフォルトの`5000`になります。


##### フック設定の名前空間

[プロジェクトフック](https://sailsguides.jp/doc/concepts/extending-sails/hooks?q=types-of-hooks)のために、フックを識別するためのユニークなキーを使って名前空間を作成し、その下にフックの設定を置く必要があります（先ほどの例でいえば、`myapihook`になります）。[インストール可能なフック](https://sailsguides.jp/doc/concepts/extending-sails/hooks?q=types-of-hooks)の場合は、`__configKey__`という特別なキーを使う必要があります（エンドユーザーが[フックのキーを必要に応じて変更できるようにするためです](https://sailsguides.jp/doc/concepts/extending-sails/hooks/using-hooks?q=changing-the-way-sails-loads-an-installable-hook)）。`__configKey__`を使った場合のデフォルトキーは、フック名になります。たとえば、`sails-hook-myawesomehook`というフックを作成し、そのフックは次の`defaults`オブジェクトを持っているとします。

```
{
   __configKey__: {
      name: "Super Bob"
   }
}
```

デフォルトでは、`sails.config.myawesomehook.name`の値が設定されます。もしエンドユーザーがフックの名前を`foo`にしたい場合は、`defaults`オブジェクトはデフォルト値を`sails.config.foo.name`として設定するでしょう。

##### `defaults`を関数として使う

普通のオブジェクトではなく関数を`defaults`に指定するのであれば、`config`という単一の引数を受け取り、上書きされるSailsの設定を受け取るような関数にします。設定の上書きはSailsを立ち上げる時のコマンドラインに渡すことや（`sails lift --prod`）、プログラムから起動や読み込みをした場合は最初の引数に渡すことで（`Sailslift({port: 1338}, ...)`）可能です。また[`.sailsrc`](https://sailsguides.jp/doc/anatomy/sailsrc)ファイルを使うこともできます。`defaults`関数は、フックのデフォルト設定値となるようなプレーンオブジェクトを返す必要があります。


<docmeta name="displayName" value=".defaults">
<docmeta name="displayName_ja" value=".defaults">
<docmeta name="stabilityIndex" value="3">
