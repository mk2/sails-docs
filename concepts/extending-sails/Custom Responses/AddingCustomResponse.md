# カスタムレスポンスの追加

独自のカスタムレスポンスを追加するには、単に`/api/responses`に作成したいメソッドと同名のファイルを追加してください。そのファイルは関数をエクスポートする必要があり、任意のパラメーターを受け取ることができます。

```javascript
/**
 * api/responses/myResponse.js
 *
 * This will be available in controllers as res.myResponse('foo');
 */

module.exports = function(message) {

  var req = this.req;
  var res = this.res;

  var viewFilePath = 'mySpecialView';
  var statusCode = 200;

  var result = {
    status: statusCode
  };

  // Optional message
  if (message) {
    result.message = message;
  }

  // If the user-agent wants a JSON response, send json
  if (req.wantsJSON) {
    return res.json(result, result.status);
  }

  // Set status code and view locals
  res.status(result.status);
  for (var key in result) {
    res.locals[key] = result[key];
  }
  // And render view
  res.render(viewFilePath, result, function(err) {
    // If the view doesn't exist, or an error occured, send json
    if (err) {
      return res.json(result, result.status);
    }

    // Otherwise, serve the `views/mySpecialView.*` page
    res.render(viewFilePath);
  });
}
```

<docmeta name="displayName" value="Adding a custom response">
<docmeta name="displayName_ja" value="カスタムレスポンスの追加">
