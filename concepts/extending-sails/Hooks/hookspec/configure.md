# `.configure()`

`configure`機能は、[`defaults`オブジェクト](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/defaults)がすべてのフックに適用された後にフックを設定する方法を提供します。カスタムフックの`configure()`関数が実行されるまでに、すべてのユーザーレベルの設定とコアフックの設定が`sails.config`へマージされます。ただし、カスタムフックのロード順序が保証されていないため、この時点で他のカスタムフックの設定に依存しないでください。

`configure`は引数のない関数として実装し、値を返すべきではありません。たとえば、次に示す`configure`関数はリモートのAPIと通信するフックに使われているものですが、APIのエンドポイントをユーザーがフックの`ssl`プロパティを`true`にするかどうかによって変更することができます。`configure`関数内で、`this.configKey`としてフックの設定キーが参照できることに注意してください。

```
configure: function() {

   // If SSL is on, use the HTTPS endpoint
   if (sails.config[this.configKey].ssl == true) {
      sails.config[this.configKey].url = "https://" + sails.config[this.configKey].domain;
   }
   // Otherwise use HTTP
   else {
      sails.config[this.configKey].url = "http://" + sails.config[this.configKey].domain;
   }
}
```

`configure`の主な利点は、すべてのフックの`configure`関数は[他の`initialize`関数](https://sailsguides.jp/doc/concepts/extending-sails/hooks/hook-specification/initialize)が実行されるより前に実行されることが保証されています。従ってフックの`initialize`関数は他のフックの設定を調べることができます。


<docmeta name="displayName" value=".configure()">
<docmeta name="displayName_ja" value=".configure()">
<docmeta name="stabilityIndex" value="3">
