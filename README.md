Simple Kibela Importer
====================

ローカルにあるMarkdownファイルを簡単にKibelaにインポートするためのスクリプトです。

Kibelaはいくつかのサービスからのデータのインポートをサポートしています。

[Kibelaヘルプセンター:インポートの共通仕様](https://support.kibe.la/hc/ja/articles/360035052772-%E3%82%A4%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%88%E3%81%AE%E5%85%B1%E9%80%9A%E4%BB%95%E6%A7%98)

Simple Kibela Importerを使うと、Kibelaが直接サポートしていないサービスからも記事のインポートを行えます。


Simple Kibela Importerでは、ファイルをそのままKibelaに記事としてインポートすることのみをサポートしています。
機能が足りない場合(例: 記事中の別記事へのURLをインポート後のものに置換したい、グループやフォルダをインポートしたい)、Simple Kibela Importerや[kibela-to-kibela](https://github.com/kibela/kibela-to-kibela)のコードを参考にすると実装がスムーズでしょう。


## Requirements

* Ruby 2.5 or higher
* Kibelaのアカウント


## Usage

まず、KibelaにインポートしたいMarkdownのファイルを用意してください。
Markdownのファイル名がそのままKibelaの記事のタイトルに、ファイルの中身が記事の本文になります。


次に、任意の方法で[simple-kibela-importer.rb](https://github.com/kibela/simple-kibela-importer/blob/master/simple-kibela-importer.rb)をダウンロードしてください。



```bash
# curlを使って、/tmp/simple-kibela-importer.rbにダウンロードする例
$ curl https://raw.githubusercontent.com/kibela/simple-kibela-importer/master/simple-kibela-importer.rb > /tmp/simple-kibela-importer.rb
```


そして https://my.kibe.la/settings/access_tokens から個人用アクセストークンを取得してください。
Read, Write両方の権限が必要です。

実行のために以下の環境変数をセットします。

```bash
# 対象のKibelaのチーム名。 bitjourney.kibe.la にアクセスしている場合、 bitjourney がチーム名となります。
$ export TEAM=TEAM_NAME

# 先程取得したアクセストークン
$ export KIBELA_ACCESS_TOKEN=secret/AT/XXXX/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```


最後に、`ruby simple-kibela-importer.rb`を実行します。
なお、デフォルトではSimple Kibela Importerはインポートを行わず、dry runを行いインポートされるファイルのリストを表示します。
実際にインポートを実行するには`APPLY`環境変数をセットしてください。

```bash
# markdownsディレクトリ以下の .md ファイルをKibelaにインポートする例
$ APPLY=1 ruby /tmp/simple-kibela-importer.rb markdowns/

# .md ファイルを直接指定する例
$ APPLY=1 ruby /tmp/simple-kibela-importer.rb foo.md bar.md
```


## 参考文献

更に発展してインポーターを実行したい場合には、次の資料が参考になるでしょう。

* https://support.kibe.la/hc/ja/articles/360035089312
  * Kibela Web APIの入門記事です。
* https://github.com/kibela/kibela-api-v1-document
  * Kibela Web APIの仕様が書かれています。
* https://github.com/kibela/kibela-to-kibela
  * あるチームのKibelaの記事を、別のKibelaのチームにインポートするスクリプトです。
