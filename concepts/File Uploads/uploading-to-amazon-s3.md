# Amazon S3へのアップロード

> 以下の例では、Amazon S3のバケットを'US East (N. Virginia)'リージョンに作成する必要があります
> アップロードに失敗した場合、アップロードは動かずAWSからの'InvalidRequest'エラーを見ることになります。

Sailsを使用すると、わずかな追加設定でAmazon S3へファイルアップロードをストリーミングできます。

まず[S3 Skipperアダプター](https://github.com/balderdashy/skipper-s3)をインストールします。

```sh
npm install skipper-s3 --save
```

次にコントローラーで使用します。

```javascript
  uploadFile: function (req, res) {
    req.file('avatar').upload({
      adapter: require('skipper-s3'),
      key: 'S3 Key',
      secret: 'S3 Secret',
      bucket: 'Bucket Name'
    }, function (err, filesUploaded) {
      if (err) return res.serverError(err);
      return res.ok({
        files: filesUploaded,
        textParams: req.allParams()
      });
    });
  }
```

<docmeta name="displayName" value="Uploading to S3">
<docmeta name="displayName_ja" value="S3へのアップロード">
