# カスタムアダプター

Sailsでは、独自のデータベースアダプターを簡単に作成できます。カスタムアダプターは、あなたのアプリ（`api/adapters/`）に直接作成することも、NPMパッケージとして公開することもできます。[カスタムアダプターの導入](https://github.com/balderdashy/sails-docs/blob/master/contributing/intro-to-custom-adapters.md)と[アダプターインターフェースのリファレンス](https://github.com/balderdashy/sails-docs/blob/master/contributing/adapter-specification.md)、それから[sails-adapter-boilerplate](https://github.com/balderdashy/sails-adapter-boilerplate)で、独自のアダプターを作成するための詳細情報をチェックしましょう。


### アダプターはどこにあるのですか？

2つの違う場所にアダプターを作成できます。

##### アプリケーションの`api/adapters/`フォルダ

アダプターが1つのアプリケーション（たとえば、既存のアダプターの短期間のフォーク）でのみ使用される場合は、そのアダプターを`api/adapters/`に入れることができます。`sails generate adapter`を実行すればすぐに生成されるものです。この場合、アダプターの名前は、`api/adapter/`内のフォルダの名前によってきます。（規約により、アダプターのエントリーポイントが`index.js`となる必要があります。）

##### 別のリポジトリ

複数のSailsアプリケーションでアダプターを共有する場合は、組織内に使うものかどうか、Sails/Node.jsコミュニティの他のメンバーのためのオープンソースパッケージかどうかに関係なく、このオプションを使用することをお勧めします。このような外部のアダプターを使用するには、`npm install your-adapter-package-name`または`npm link your-adapter-package-name`を実行する必要があります。

> オープンソースのアダプターを始める前に、プロジェクトがすでに存在しているか調べるために、`sails-databasename`と`waterline-databasename`でGithubを検索してみることをお勧めします、もしあるのであれば、既存のアダプターの作成者に連絡を取り、新しいプロジェクトを始める代わりにコントリビュートするのが、一般的には良い考え方です。ほとんどの開発者は助けを歓迎するでしょうし、その結果より良い品質のアダプターが得られるかもしれません。存在しない場合は、`sails-databasename`という規約に従った名前で新しいプロジェクトを作成することをお勧めします。


### カスタムアダプターには何が入っていますか？
### What goes in a custom adapter?

In Sails, database adapters expose **interfaces**, which imply a conract to implemnt certain functionality.  This allows us to guarantee conventional usage patterns across multiple models, developers, apps, and even companies, making app code more maintainable, efficient, and reliable.  Adapters are primarily useful for integrating with databases, but they can also be used to support any open API or internal/proprietary web service that is _purely_ RESTful.

> Not everything fits perfectly into a RESTful/CRUD mold.  Sometimes the service you're integrating with has more of an RPC-style interface, with one-off methods.  For example, consider an API request to send an email, or to read a remote sensor on a piece of connected hardware.  For that, you'll want to write or extend a machinepack.  [Learn more about machinepacks here](http://node-machine.org).


### What kind of things can I do in an adapter?

Adapters are mainly focused on providing model-contextualized CRUD methods.  CRUD stands for create, read, update, and delete.  In Sails/Waterline, we call these methods `create()`, `find()`, `update()`, and `destroy()`.

For example, a `MySQLAdapter` implements a `create()` method which, internally, calls out to a MySQL database using the specified table name and connection informtion and runs an `INSERT ...` SQL query.

In practice, your adapter can really do anything it likes-- any method you write will be exposed on the raw datastore objects and any models which use them.

### Building a custom adapter

Check out the [Sails docs](https://sailsjs.com/documentation), or see [`config/datastores.js`](https://sailsjs.com/anatomy/config/datastores.js) in a new Sails project for information on setting up this adapter in a Sails app.


#### Running the tests

Configure the interfaces you plan to support (and the targeted version of Sails) in the adapter's `package.json` file:

```javascript
{
  //...
  "sails": {
  	"adapter": {
	    "sailsVersion": "^1.0.0",
	    "implements": [
	      "semantic",
	      "queryable"
	    ]
	  }
  }
}
```

In your adapter's directory, run:

```sh
$ npm test
```


#### Publish your adapter

> You're welcome to write proprietary adapters and use them any way you wish--
> these instructions are for releasing an open-source adapter.

1. Create a [new public repo](https://github.com/new) and add it as a remote (`git remote add origin git@github.com:yourusername/sails-youradaptername.git)
2. Make sure you attribute yourself as the author and set the license in the package.json to "MIT".
3. Run the tests one last time.
4. Do a [pull request to sails-docs](https://github.com/balderdashy/sails-docs/edit/master/concepts/extending-sails/Adapters/adapterList.md) adding your adapter's repo.
5. We'll update the documentation with information about your new adapter
6. Let the people of world adore you with lavish praises.
7. Run `npm version patch`
8. Run `git push && git push --tags`
9. Run `npm publish`



### Why would I need a custom adapter?

When building a Sails app, the sending or receiving of any asynchronous communication with another piece of hardware can _technically_ be normalized into an adapter.  (viz. API integrations)

> **From Wikipedia:**
> *http://en.wikipedia.org/wiki/Create,_read,_update_and_delete*

> Although a relational database provides a common persistence layer in software applications, numerous other persistence layers exist. CRUD functionality can be implemented with an object database, an XML database, flat text files, custom file formats, tape, or card, for example.

In other words, Waterline is not _necessarily_ just an ORM for your database.  It is a purpose-agnostic, open standard and toolset for integrating with all kinds of RESTful services, datasources, and devices, whether it's LDAP, Neo4J, or [a lamp](https://www.youtube.com/watch?v=OmcQZD_LIAE).

> **But remember:** only use Waterline adapters for communicating with databases and APIs that support a "create", "read", "update", and "destroy" interface.  Not everything fits into that mold, and there are [better, more generic ways](http://node-machine.org) to address those other use cases.


### Why should I build a custom adapter?

To recap, writing your API integrations as adapters is **easier**, takes **less time**, and **absorbs a considerable amount of risk**, since you get the advantage of a **standardized set of conventions**, a **documented API**, and a **built-in community** of other developers who have gone through the same process.  Best of all, you (and your team) can **reuse the adapter** in other projects, **speeding up development** and **saving time and money**.

Finally, if you choose to release your adapter as open-source, you provide a tremendous boon to our little framework and our budding Sails.js ecosystem.  Even if it's not via Sails, I encourage you to give back to the OSS community, even if you've never forked a repo before-- don't be intimidated, it's not that bad!

The more high-quality adapters the Sails community collectively releases as open-source, the less repetitive work we all have to do when we integrate with various databases and services.  Our vision is to make building server-side apps more fun and less repetitive for everyone, and that happens one community adapter (or machinepack/driver/generator/view engine/etc.) at a time.


### What is an adapter interface?

The functionality of database adapters is as varied as the services they connect.  That said, there is a standard library of methods, and a support matrix you should be aware of.  Adapters may implement some, all, or none of the interfaces below, but rest assured that **if an adapter implements one method in an interface, it should implement *all* of them**.  This is not always the case due to limitations and/or incomplete implementations, but at the very least, a descriptive error message should be used to keep developers informed of what's supported and what's not.

> For more information, check out the Sails docs, and specifically the [adapter interface reference](https://github.com/balderdashy/sails-docs/blob/master/contributing/adapter-specification.md).

### Are there examples I can look at?

If you're looking for some inspiration, a good place to start is with the core adapters.  Take a look at **[MySQL](https://github.com/balderdashy/sails-mysql)**, **[PostgreSQL](https://github.com/balderdashy/sails-postgresql)**, **[MongoDB](https://github.com/balderdashy/sails-mongo)**, **[Redis](https://github.com/balderdashy/sails-redis)**, or local [disk](https://github.com/balderdashy/sails-disk).


### Where do I get help?

An active community of Sails and Waterline users exists on GitHub, Stack Overflow, Google groups, IRC, Gitter, and more.  See the [Support page](https://sailsjs.com/support) for a list of recommendations.

> If you have an unanswered question that isn't covered here, and that you feel would add value for the community, please feel free to send a PR adding it to this section of the docs.




<docmeta name="displayName" value="Custom adapters">
