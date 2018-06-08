# ホスティング

Node/Sailsホスティングプロバイダと、いくつかのコミュニティチュートリアルリストがあります。ほとんどの場合、Sailsアプリケーションをデプロイするプロセスは、他のNode.jsアプリケーションとまったく同じです。実際に本番環境にデプロイする前に、念のためこのドキュメントの[他のページ](https://sailsguides.jp/doc/concepts/deployment)（[`config/env/production.js` file](https://sailsguides.jp/doc/anatomy/config/env/production-js)も）を見たり、必要な調整を行ってください。


### Heroku

<a title="Deploy your Sails/Node.js app on Heroku" href="http://heroku.com"><img style="width:285px;" src="https://sailsjs.com/images/deployment_heroku.png" alt="Heroku logo"/></a>

"Web App"テンプレートを使用して生成されたSailsプロジェクトを展開する、最も簡単な（そして無料の）方法はおそらくHeroku経由です。

1. GitHubリポジトリを作成し、コードを`master`ブランチまでプッシュします。
2. Herokuのパイプラインを作成し、そのパイプライン内のステージングアプリを作成する（例えば`my-cool-site-staging`）
3. ポイントアンドクリックインターフェースを使用して、Herokuアプリをステージングして、GitHubリポジトリの`deploy`ブランチから自動デプロイするように設定します。
4. "Add-ons"では、Papertrailをロギング用に、Redis2Goを本番用セッションストアとして（該当する場合はソケットメッセージを配信するために）、スケジュールされたジョブ用のHeroku Scheduler（該当する場合）、データベースにはMySQLかPostgreSQL、またはMongoDB（任意のものを選ぶ）。
5. プロジェクトの`config/production.js`と`config/staging.js`にざっと目を通り、設定します。Herokuのインターフェース上で、リポジトリにあるハードコードするにはあまりにも機密であるような情報（たとえばデータベースの認証情報）などを"Config Variables"として設定することができます。（例については、バンドルされた設定ファイルを参照してください。）
6. ターミナルで、すべてがプル/プッシュされていて、GitHubのリモートマスターブランチと100％同期していることを確認してください。
7. 次に`sails run deploy`をタイプします。

[ここ](https://platzi.com/cursos/javascript-pro/)で実際のデモンストレーションを見ることができます。

##### HerokuをNode.js/Sails.jsで使用するためのその他のリソース：

+ [Platzi: Full Stack JavaScript: Pt 5 (2018)](https://platzi.com/cursos/javascript-pro/)
+ [Hello Sails.js: Hosting your Sails.js application on Heroku (2016-2017)](https://hellosails.com/hosting-your-sails-js-application-heroku/)
+ [Platzi: Develop Apps with Sails.js: Pt 2 (2015)](https://courses.platzi.com/classes/develop-apps-sails-js/)  _（パート2を見てください）_
+ [Sails.js on Heroku (2015)](http://vort3x.me/sailsjs-heroku/)
+ [SailsCasts: Deploying a Sails App to Heroku (2013)](http://irlnathan.github.io/sailscasts/blog/2013/11/05/building-a-sails-application-ep26-deploying-a-sails-app-to-heroku/)

<!--
More 2013:
+ [StackOverflow: Sails.js + Heroku (2013)](http://stackoverflow.com/a/20184907/486547)
+ https://groups.google.com/forum/#!topic/sailsjs/vgqJFr7maSY
+ https://github.com/chadn/heroku-sails
+ http://dennisrongo.com/deploying-sails-js-to-heroku
-->

### Microsoft Azure

<a title="Deploy a Sails.js web app to Azure App Service" href="https://docs.microsoft.com/en-us/azure/app-service-web/app-service-web-nodejs-sails"><img style="width:350px;" src="https://sailsjs.com/images/deployment_azure.png" alt="Azure logo"/></a>

+ [Deploy a Sails.js web app to Azure App Service (2017)](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-web-nodejs-sails)
+ [Deploying Sails.js to Azure Web Apps (2015)](https://blogs.msdn.microsoft.com/partnercatalystteam/2015/07/16/y-combinator-collaboration-deploying-sailsjs-to-azure-web-apps/)

### Google Cloud Platform

<a title="Deploy your Sails/Node.js app to Google Cloud Platform" href="https://cloud.google.com/nodejs/resources/frameworks/sails"><img style="width:350px;" src="https://sailsjs.com/images/deployment_googlecloud.png" alt="Google Cloud Platform logo"/></a>

> Google Cloud PlatformでエンタープライズグレードのSails.jsアプリケーションを実行するのは簡単です。作成したアプリケーションはGoogleのすべての製品に使用されるインフラストラクチャと同じインフラストラクチャ上で実行されるため、数百人にも数百万人にもわたって、すべてのユーザーにサービスを提供できると確信できます。

+ [Run Sails.js on Google Cloud Platform (2016)](https://cloud.google.com/nodejs/resources/frameworks/sails)
+ [Deploying Sails.js to Google Cloud (2016)](http://www.mot.la/2016-06-04-deploying-sails-js-to-google-cloud.html)
+ [A couple of Googlers demonstrate and deploy their app built on Sails.js and GO in a talk called `runtime:yours` at Google Cloud Platform Live (2014)](https://www.facebook.com/sailsjs/posts/721341477911963)


### DigitalOcean

<a title="DigitalOcean" href="https://aws.amazon.com/"><img style="width:225px;" src="https://sailsjs.com/images/deployment_digitalocean.png" alt="DigitalOcean logo"/></a>

+ [Troubleshooting: Can't install Sails.js on DigitalOcean (2017)](https://www.digitalocean.com/community/questions/can-t-install-sails-js)
+ [How to use PM2 to set up a Node.js production environment on an Ubuntu VPS (2014)](https://www.digitalocean.com/community/articles/how-to-use-pm2-to-setup-a-node-js-production-environment-on-an-ubuntu-vps)
+ [How to create a Node.js app using Sails.js on an Ubuntu VBS (2013)](https://www.digitalocean.com/community/articles/how-to-create-an-node-js-app-using-sails-js-on-an-ubuntu-vps)

<!--
More 2013:
+ https://www.digitalocean.com/community/articles/how-to-host-multiple-node-js-applications-on-a-single-vps-with-nginx-forever-and-crontab
-->


### Amazon Web Services (AWS)

<a title="Amazon Web Services (AWS)" href="https://aws.amazon.com/"><img style="width:275px;" src="https://sailsjs.com/images/deployment_aws.png" alt="AWS logo"/></a>


+ [Creating a Sails.js application on AWS (2017)](http://bussing-dharaharsh.blogspot.com/2013/08/creating-sailsjs-application-on-aws-ami.html) _（[ServerFaultに関するこの質問も参照してください](http://serverfault.com/questions/531560/creating-an-sails-js-application-on-aws-ami-instance)）_
+ [Deploy a Sails app to AWS](https://www.distelli.com/docs/tutorials/build-and-deploy-sails-angular-application)
+ [Your own mini-Heroku on AWS (2014)](http://blog.grio.com/2014/01/your-own-mini-heroku-on-aws.html)
+ [Deploying Sails/Node.js apps to AWS (2012)](http://cloud.dzone.com/articles/how-deploy-nodejs-apps-aws-mac)



### PM2 (KeyMetrics)

<a title="About PM2" href="http://pm2.keymetrics.io/"><img style="width:285px;" src="https://sailsjs.com/images/deployment_pm2.png" alt="PM2 logo"/></a>

+ [PM2によるデプロイ](http://devo.ps/blog/goodbye-node-forever-hello-pm2/)

> 注：PM2は実際にはホスティングプラットフォームではありませんが、このセクションでは、知ることで十分です。


### OpenShift (Red Hat)

<a href="https://www.openshift.com/"><img style="width:350px;" alt="Red Hat™ OpenShift logo" src="https://sailsjs.com/images/deployment_openshift.png"/></a>

+ [Deploying a Sails / Node.js application to OpenShift (2017)](https://gist.github.com/mikermcneil/b6136aa219f6d15b01a05b14cc681fcb)
+ [Listening to a different IP address on OpenShift (2017-2018)](https://coderwall.com/p/dhhfcw/sailsjs-listening-on-a-different-ip-address) _（ありがとう、[@otupman](https://github.com/otupman)）_
+ [Get Sails/Node.js running on OpenShift (2017)](https://gist.github.com/mdunisch/4a56bdf972c2f708ccc6) _（かなり古いですが、まだ参考になります。ありがとう、[@mdunisch](https://github.com/mdunisch)。）_

<!--
### Xervo (formerly Modulus)

<a href="https://xervo.io"><img alt="Xervo logo" style="display: inline-block; width: 85px;" src="https://sailsjs.com/images/deployment_xervo.png"/>&nbsp; &nbsp;<img alt="Modulus logo" style="display: inline-block; width: 85px;" src="https://sailsjs.com/images/deployment_modulus.png"/></a>

+ [Customer Spotlight: Sails.js](https://blog.xervo.io/sails-js)
-->

### Nanobox

+ [Getting Started: A Simple Sails.js App (2017)](https://content.nanobox.io/a-simple-sails-js-example-app/) on Nanobox
+ [Quickstart: nanobox-sails](https://github.com/nanobox-quickstarts/nanobox-sails)
+ [Official Sails.js Guides](https://guides.nanobox.io/nodejs/sails/)
+ [Official Nanobox Docs](https://docs.nanobox.io)
+ [Nanobox Slack](https://slack.nanoapp.io)


### exoscale / CloudControl

+ [Deploying a Sails.js application to exoscale / CloudControl](https://github.com/exoscale/apps-documentation/blob/88d9f157093f0690f139337ff934c027482d4727/Guides/NodeJS/Sailsjs.md) _（[チュートリアルの描画されたバージョン](https://webcache.googleusercontent.com/search?q=cache:gq8UZXarNq8J:https://community.exoscale.ch/documentation/apps/nodejs-app-sailsjs/+&cd=1&hl=en&ct=clnk&gl=us)）_


### RoseHosting

> RoseHostingのホスティングプランはすべて無料で24時間年中無休でサポートされているため、[サポートチーム](https://www.rosehosting.com/support.html)に連絡してSails.jsをインストールして設定します。

 + [Install Sails.js with Apache as a reverse proxy on CentOS 7 (2016)](https://www.rosehosting.com/blog/install-sails-js-with-apache-as-a-reverse-proxy-on-centos-7/)
 + [Install Sails.js on Ubuntu (2014)](https://www.rosehosting.com/blog/install-the-sails-js-framework-on-an-ubuntu-vps/)


### 他の選択肢

+ [Heroku](https://stackshare.io/heroku)のようなものであれば、ほかにたくさんの[Node.js/Sails.jsをサポートしているPaaSがあります](https://stackshare.io/heroku/alternatives)
+ [Microsoft Azure](https://stackshare.io/microsoft-azure)や[EC2](https://stackshare.io/amazon-ec2)のようなものであれば、ほかにたくさんの[Node.js/Sails.jsが動く"ベアメタル"もしくはIaaSなサーバーがあります](https://stackshare.io/amazon-ec2/alternatives)
+ [Cloudflare](https://stackshare.io/cloudflare)のようなものであれば、ほかに[静的なあアセットをホストするのに最適化された、優れたCDNがあります](https://stackshare.io/cloudflare/alternatives)

<docmeta name="displayName" value="Hosting">
<docmeta name="displayName_ja" value="ホスティング">
