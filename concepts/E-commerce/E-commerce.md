# Eコマース

よくあるウェブアプリケーションフレームのように、SailsはEコマースアプリケーションにも使うことができます。プロジェクトの特定のニーズに応じて、Sailsを自分たちのカスタムソリューションの基礎として利用したり、既存のEコマースプラットフォームと統合したりすることができます。

SailsでカスタムのEコマースソリューションを構築する場合、データの構築方法は多数の選択肢があります。始め方としてお勧めなのは、4つの[モデル](https://sailsguides.jp/doc/concepts/models-and-orm)で始めることです。その4つのモデルは、`User`（"Web app"テンプレートでSailsアプリケーションを新しく生成した場合はすでに含まれています）と、`CartItem`、`Product`、そして`Order`です。[関連付け](https://sailsguides.jp/doc/concepts/models-and-orm/associations)を利用することで、ショッピングカートやユーザーの個々の注文履歴などを追跡できます。

> 最初からカスタムのEコマース機能を動かすことが難しい場合は、既存のSailsベースのプラットフォーム（たとえば[Ymple](https://www.ymple.com/en/)）の上にSailsアプリケーションを構築する方法も検討してみてください。

<docmeta name="displayName" value="E-commerce">
<docmeta name="displayName_ja" value="Eコマース">
