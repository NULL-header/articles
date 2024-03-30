---
title: "Docker DesktopでサッとHTMLServerを立てる"
emoji: "🚒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["docker","nginx","html"]
published: true 
---

# まえがき

単純にHTMLをローカルで配信したいというニーズは時々発生します。  
そのほとんどが調査目的で、たとえばJSの特定の構文のふるまいの実測値を得たいが開発者コンソールでは手狭であったり、経験が少ない機能の最小構成での試し書きをしたかったりします。  
そういうときのためのテクニックとして、Docker上のnginxで配信する手法を当記事で紹介します。  

# 目次

- [まえがき](#まえがき)
- [目次](#目次)
- [要約](#要約)
- [筆者の環境](#筆者の環境)
- [DockerDesktopでのセットアップ](#dockerdesktopでのセットアップ)
  - [コンテナイメージ](#コンテナイメージ)
  - [初期設定](#初期設定)
  - [立ち上げ](#立ち上げ)
- [公式イメージのREADME](#公式イメージのreadme)
- [捕捉](#捕捉)
- [あとがき](#あとがき)
- [参考](#参考)

# 要約

Docker公式イメージのnginxは`/usr/share/nginx/html/`を配信するので、そこへボリュームをかけるとよい。  

# 筆者の環境

| Env Kind          | Value          |
| ----------------- | -------------- |
| HostOS            | Windows11 Home |
| Virtualizer       | Docker Desktop |
| Virtualize Engine | WSL2           |
| GuestOS on WSL    | Ubuntu         |
| GuestOS on Docker | Alpine         |

# DockerDesktopでのセットアップ

当項目にHTMLをDockerDesktopで配信する手順を通しで記載していきます。  

## コンテナイメージ

DockerDesktopから`Ctrl+K`のショートカットで開く検索モーダルから、nginxを検索します。すると公式のものが出てきますので、こちらをPullして利用します。  
Tagはなんでもよいのですが、筆者はAlpineを利用しています。  

![nginxを検索する様子のスクリーンショット](/images/abe4f2bd1cf94b/search-nginx.png)

本来イメージはDockerfileやdocker-compose.ymlで宣言する流れがありますが、今回はツールとしての利用に留め、開発や運用に直接関わらないものとして手続き的に進めます。  
なお、nginxの行をクリックすることで詳細タブが開き、READMEを読みこともできます。しかしこのままだと読みづらいので、`View on Hub`のリンクから該当ページを開いて読むことをおすすめします。

![nginxの詳細を開く様子のスクリーンショット](/images/abe4f2bd1cf94b/nginx-detail.png)

## 初期設定

イメージをDockerDesktopからPullしましたら、次は各種設定をしてコンテナの起動の準備をしましょう。  
イメージ一覧タブからイメージの実行ボタンをクリックし、設定画面を開きます。  
各項目は基本的に解説をする必要もないほどシンプルですが、一つ注意点があります。  

![nginxの設定をする様子のスクリーンショット](/images/abe4f2bd1cf94b/nginx-run-config.png)

公式nginxのイメージはそのままコンテナとして立ち上げると、`/usr/share/nginx/html/`を配信します。ここをボリュームとして設定することで、配信したいHTMLを指定できるのです。なお当然ですが、ファイル名でなく、配信したいファイルが存在するディレクトリを指定する必要があります。  

## 立ち上げ

そのまま実行することで、指定したディレクトリに対して`localhost:8080`でアクセスすることができます。適宜ポートを変えても問題ありません。  

# 公式イメージのREADME

上記の流れのコアである、nginxの配信箇所と、そこをボリュームでマウントする方法については公式イメージのREADMEに記載されています。たとえば他に、シンプルにPostgreSQLを立てたい場合も、永続化のためにボリュームとすべきパスがREADMEに記載されています。  
READMEと言うと機能やメリットの紹介といった先入観もありますが、公式イメージのREADMEはドキュメントとしての意味合いが強く、まずは一度目を通しておくと後々便利なパターンがあるように感じます。  

# 捕捉

WSL上のファイルを指定したい場合は、`\\wsl$`とネットワークデバイスとしてアクセスすることができます。Dockerのイメージからコンテナを作る設定画面のとき、エクスプローラーで開いてこれを活用すると便利です。

# あとがき

以下は当記事のまえがきの記述です。

> 単純にHTMLをローカルで配信したいというニーズは時々発生します。  
> そのほとんどが調査目的で、たとえばJSの特定の構文のふるまいの実測値を得たいが開発者コンソールでは手狭であったり、経験が少ない機能の最小構成での試し書きをしたかったりします。  

このニーズですが一応、ローカルファイルパスでhtmlをブラウザに読み込ませる、といった対処法も可能ではあります。ですがクロスオリジンの都合で通信がカットされたり、利用できるAPIに制限がかかる場合があります。  
またローカルファイルパスという特殊な条件下での計測が、実際に参考になるのか、といった見方をすることもできます。  
しかしローカルにnginxを構築するのは少々手間で、必要なくなった後の後始末も面倒になりがちです。  
こういうとき、Dockerが環境ごと必要なツールを抽象化してしてくれる、というふるまいを覚えておくとかなり楽になります。  
開発環境や本番環境の持ち運びの簡便性がDocker採用の第一の理由である場合も多いですが、ツールに必要なセットアップの簡便化、抽象化を担うこともできる、という発見をしてつい感動してしまい、当記事を書きました。  

# 参考

- https://hub.docker.com/_/nginx?uuid=202366E8-42F7-4114-9919-973684414D0A
  - DockerHub上でのnginx
- https://learn.microsoft.com/ja-jp/windows/wsl/filesystems
  - WSL上のファイルの開き方が例として一行乗っている