# アプリケーションイベント

### 概要

SailsアプリケーションインスタンスはNodeの[`EventEmitter`インターフェイス](https://nodejs.org/api/events.html#events_class_eventemitter)を継承しています。つまり、カスタムイベントを発行したり監視したりできます。アプリケーションコードでSailsイベントを直接利用することは推奨されませんが（スケーラビリティを実現するために、アプリケーションができるだけステートレスになるようにする必要があるため）、[フック](https://sailsguides.jp/doc/concepts/extending-sails/hooks)や[アダプター](https://sailsguides.jp/doc/concepts/extending-sails/adapters)でSailsを拡張するときや、テスト環境で非常に便利に使うことができます。

### イベントを使うべきですか？

ほとんどのSails開発者は、アプリケーションイベントを処理することはないでしょう。Sailsアプリケーションインスタンスによって生成されたイベントは、独自のカスタムフックを構築するときに使用されるように設計されています。技術的にはどこからでも使用できますが、ほとんどの場合において使用しないでください。コントローラ、モデル、サービス、設定、またはSailsアプリのユーザランドのコード内のどこでもイベントを使わないでください（カスタムアプリケーションフックを`api/hooks/`に作成しない限りにおいて）。

### Sailsによって発行されるイベント

以下は、Sailsインスタンスによって発行される組み込みイベントです。Nodeの任意のEventEmitterと同様に、次のイベントを`sails.on()`を使って待ち受けることができます。

```javascript
sails.on(eventName, eventHandlerFn);
```

余分な情報を伴って放出されるイベントはないので、`eventHandlerFn`の引数は必要ありません。

| イベント名 | いつ発行されるのか |
|:-----------|:----------------|
| `ready`    | アプリケーションがロードされブートストラップが実行されたが、まだリクエストを待ち受けていない。 |
| `lifted`   | アプリケーションが立ち上がり、リクエストを待ち受けている。 |
| `lower`  | アプリケーションが終了しようとしていて、リクエストの待ち受けを止めている。 |
| `hook:<hook identity>:loaded` | 指定されたidentityを持つフックが読み込まれ、`initialize()`メソッドが正常に実行された。 |

> `.on()`という関数に加えて、Sailsは`sails.after()`という有用な関数を公開しています。詳細については、Sailsコアの[インラインドキュメント](https://github.com/balderdashy/sails/blob/fd2f9b6866637143eda8e908775365ca52fab27c/lib/EVENTS.md#usage)を参照してください。

<docmeta name="displayName" value="Events">
<docmeta name="displayName_ja" value="イベント">
