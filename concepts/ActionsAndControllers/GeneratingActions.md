# コントローラーまたはスタンドアロンアクションの生成

[`sails-generate`](https://sailsguides.jp/doc/reference/command-line-interface/sails-generate)をSailsのコマンドラインツールから使うと、コントローラーもしくは個別のアクションだけをすばやく生成できます。


### コントローラーの生成

例えば、コントローラーを生成するには次のようにします。

```sh
$ sails generate controller user
```

Sailsは`api/controllers/UserController.js`を次の内容で生成します。

```javascript
/**
 * UserController.js
 *
 * @description :: Server-side controller action for manging users.
 * @help        :: See https://sailsguides.jp/doc/concepts/controllers
 */
module.exports = {

}
```

### スタンドアロンアクションの生成

スタンドアロンアクションを生成するには、次のコマンドを実行します。

```sh
$ sails generate action user/signup
info: Created an action!
Using "actions2"...
[?] https://sailsjs.com/docs/concepts/actions
```

Sailsは`api/controllers/user/sign-up.js`を次の内容で生成します。

```javascript
/**
 * user/sign-up.js
 *
 * @description :: Server-side controller action for handling incoming requests.
 * @help        :: See https://sailsguides.jp/doc/concepts/controllers
 */
module.exports = {


  friendlyName: 'Sign up',


  description: '',


  inputs: {

  },


  exits: {

  },


  fn: function (inputs, exits) {

    return exits.success();

  }


};

```

もしくは、[classic actions](https://sailsguides.jp/doc/concepts/actions-and-controllers#?classic-actions)のインターフェースを使用します。


```sh
$ sails generate action user/signup --no-actions2
info: Created a traditional (req,res) controller action, but as a standalone file
```

Sailsは`api/controllers/user/sign-up.js`を次の内容で生成します。

```javascript
/**
 * Module dependencies
 */

// ...


/**
 * user/signup.js
 *
 * Signup user.
 */
module.exports = function signup(req, res) {

  sails.log.debug('TODO: implement');
  return res.ok();

};
```



<docmeta name="displayName" value="Generating actions and controllers">
<docmeta name="displayName_ja" value="アクションとコントローラを生成する">
