# ファイルのアップロード

Sailsでファイルをアップロードする方法は、素のNode.jsやExpressアプリケーションでアップロードする方法と似ています。しかし、PHPや.NET、Python、Ruby、そしてJavaなどの他のサーバーサイドプラットフォームを以前に学んでいた場合は、違和感を感じるでしょう。しかし心配しないでください。コアチームは、拡張性と安全性を維持しながらファイルのアップロードを容易にするために尽力しています。

Sailsには、サーバーのファイルシステム（ハードディスクなど）だけでなく、Amazon S3、MongoDBのグリッド、またはその他のサポートされているファイルアダプターにストリーミングファイルのアップロードを簡単に実装できる[Skipper](https://github.com/balderdashy/skipper)という強力な「ボディパーサー」が付属しています。


### ファイルをアップロードする

ファイルは _ファイルパラメータ_ としてHTTP Webサーバーにアップロードされます。同じように、"name"、"email"、"password"のようなテキストパラメータを持つURLにフォームPOSTを送信する場合、ファイルを"avatar"や"newSong"のようなファイルパラメータとして送信します。

この簡単な例を見てください。

```javascript
req.file('avatar').upload(function (err, uploadedFiles) {
  // ...
});
```

ファイルはコントローラーの`action`内部でアップロードする必要があります。ここでは、ユーザーがアバター画像をアップロードして自分のアカウントに関連付ける方法を示す詳細な例を示します。ポリシー内ですでにアクセス制御を行っていること、およびログインしているユーザーのIDを`req.session.userId`へ格納していることを前提としています。

```javascript
// api/controllers/UserController.js
//
// ...


/**
 * Upload avatar for currently logged-in user
 *
 * (POST /user/avatar)
 */
uploadAvatar: function (req, res) {

  req.file('avatar').upload({
    // don't allow the total upload size to exceed ~10MB
    maxBytes: 10000000
  },function whenDone(err, uploadedFiles) {
    if (err) {
      return res.serverError(err);
    }

    // If no files were uploaded, respond with an error.
    if (uploadedFiles.length === 0){
      return res.badRequest('No file was uploaded');
    }

    // Get the base URL for our deployed application from our custom config
    // (e.g. this might be "http://foobar.example.com:1339" or "https://example.com")
    var baseUrl = sails.config.custom.baseUrl;

    // Save the "fd" and the url where the avatar for a user can be accessed
    User.update(req.session.userId, {

      // Generate a unique URL where the avatar can be downloaded.
      avatarUrl: require('util').format('%s/user/avatar/%s', baseUrl, req.session.userId),

      // Grab the first file and use it's `fd` (file descriptor)
      avatarFd: uploadedFiles[0].fd
    })
    .exec(function (err){
      if (err) return res.serverError(err);
      return res.ok();
    });
  });
},


/**
 * Download avatar of the user with the specified id
 *
 * (GET /user/avatar/:id)
 */
avatar: function (req, res){

  User.findOne(req.param('id')).exec(function (err, user){
    if (err) return res.serverError(err);
    if (!user) return res.notFound();

    // User has no avatar image uploaded.
    // (should have never have hit this endpoint and used the default image)
    if (!user.avatarFd) {
      return res.notFound();
    }

    var SkipperDisk = require('skipper-disk');
    var fileAdapter = SkipperDisk(/* optional opts */);

    // set the filename to the same file as the user uploaded
    res.set("Content-disposition", "attachment; filename='" + file.name + "'");

    // Stream the file down
    fileAdapter.read(user.avatarFd)
    .on('error', function (err){
      return res.serverError(err);
    })
    .pipe(res);
  });
}

//
// ...
```

#### ファイルはどこへ行くのですか？

デフォるtの`receiver`を使っていた場合、ファイルは`myApp/.tmp/uploads/`ディレクトリへアップロードされて移動します。`dirname`オプションで場所を変更することが可能です。`.upload()`関数を呼び出すときとskipper-diskアダプターを呼び出すとき、両方にこのオプションを指定する必要があることに注意してください（アップロードとダウンロードを同じ場所からできるようにするため）。

#### カスタムフォルダーへのアップロード

先補dの例ではファイルを.tmp/uploadsへアプロードします。では、どのようにしてカスタムフォルダを設定するのでしょうか？（例えば'assets/images'など）これを実現するには、以下のようにアップロード関数にオプションを追加します。

```javascript
req.file('avatar').upload({
  dirname: require('path').resolve(sails.config.appPath, 'assets/images')
},function (err, uploadedFiles) {
  if (err) return res.serverError(err);

  return res.json({
    message: uploadedFiles.length + ' file(s) uploaded successfully!'
  });
});
```

### ファイルアップロードと同じ形式で、テキストパラメータを送信する

上で述べたように、"name"や"email"のようなテキストパラメータをファイルアップロードフィールドとともにSailsアクションに送ることができます。ただし、テキストフィールドは、_フォームのファイルフィールドの前に表示され_、処理される必要があります。これは、Sailsがファイルのアップロード中にアクションコードを実行できるようにするために重要です（ファイルアップロードが終了するのを待たずに）。詳細については、[Skipperのドキュメント](https://github.com/balderdashy/skipper#text-parameters)を参照してください。

### 例

#### `api`を生成する

最初に、ファイルを提供や保存したりするための`api`を生成します。sailsコマンドラインツールを使います。

```sh
$ sails generate api file

debug: Generated a new controller `file` at api/controllers/FileController.js!
debug: Generated a new model `File` at api/models/File.js!

info: REST API generated @ http://localhost:1337/file
info: and will be available the next time you run `sails lift`.
```

#### コントローラーのアクションを作成する

ファイルアップロードの初期化の初期化を行う`index`アクションと、ファイルの受け取りを行う`upload`アクションを作成しましょう。

```javascript

// myApp/api/controllers/FileController.js

module.exports = {

  index: function (req,res){

    res.writeHead(200, {'content-type': 'text/html'});
    res.end(
    '<form action="http://localhost:1337/file/upload" enctype="multipart/form-data" method="post">'+
    '<input type="text" name="title"><br>'+
    '<input type="file" name="avatar" multiple="multiple"><br>'+
    '<input type="submit" value="Upload">'+
    '</form>'
    )
  },
  upload: function  (req, res) {
    req.file('avatar').upload(function (err, files) {
      if (err)
        return res.serverError(err);

      return res.json({
        message: files.length + ' file(s) uploaded successfully!',
        files: files
      });
    });
  }

};
```

## より詳しく

+ [Skipperドキュメント](https://github.com/balderdashy/skipper)
+ [Amazon S3へのアップロード](https://sailsguides.jp/doc/concepts/file-uploads/uploading-to-s-3)
+ [Mongo GridFSへのアップロード](https://sailsguides.jp/doc/concepts/file-uploads/uploading-to-grid-fs)



<docmeta name="displayName" value="File uploads">
<docmeta name="displayName" value="ファイルアップロード">
