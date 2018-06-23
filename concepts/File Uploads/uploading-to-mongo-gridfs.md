# Mongo GridFSへのアプロード

MongoDBへのファイルアップロードは、MongoのGridFSファイルシステムによって実現されています。Sailsでは、[MongoDBのGridFS](https://github.com/willhuang85/skipper-gridfs)向けSkipperアダプターを使用しわずかな追加設定で達成できます。

まずインストールします。

```sh
$ npm install skipper-gridfs --save
```

そしてコントローラーで使用します。

```javascript
  uploadFile: function (req, res) {
    req.file('avatar').upload({
      adapter: require('skipper-gridfs'),
      uri: 'mongodb://[username:password@]host1[:port1][/[database[.bucket]]'
    }, function (err, filesUploaded) {
      if (err) return res.serverError(err);
      return res.ok();
    });
  }
```

<docmeta name="displayName" value="Uploading to GridFS">
<docmeta name="displayName_ja" value="GridFSへアップロードする">
