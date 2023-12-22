# terraform_main_source

## 立ち上げ概要

AWSの2つのAZにてパブリック/プライベートSubnetを作成しており、

すべてのサブネットでSSMで入れるサーバが４台稼働。

プライベートEC2からはNAT Gatewayで外部へ接続可能。

プライベートEC2からはALBに接続されており、SSLで外部からのWebサイトアクセス可能。

RDSについてはプライベートEC2から接続可能とする。

ElastiCache（Redis）の立ち上げも行え、プライベートEC2から接続可能とする。

## 前提

以下のページなどを参考に、terraform稼働環境を作成し、AWSでの適当なリソースが作成できる状態にあること。

[Terraformをdocker環境で立ち上げてみる。](https://qiita.com/naritomo08/items/7e5a9d1b7eaf18dc0060)

Dockerを使用しない場合、以下のコマンドを利用できている状態になっていること。
```bash
aws

brew
*Terraform導入時に必要

tfenv
*terraform稼働コンテナを利用しない場合は必要
```

### (コンテナ利用しない場合)指定バージョン(1.５．７)のterraformを導入する。

```bash
tfenv install
```

## terraformソースファイル入手

terraformを動かすフォルダ内にて、以下コマンドを稼働する。

```bash
git clone https://github.com/naritomo08/terraform_main_source_public.git
cd terraform_main_source_public
```

後にファイル編集などをして、git通知が煩わしいときは
作成したフォルダで以下のコマンドを入れる。

```bash
 rm -rf .git
```

## 作成（基本ネットワーク、EC2作成）

tfstateフォルダに行き、tfstate用S3を作成する。

作成する際、”main.tf”内の<バケット名>部分を適当な名前に変更すること。

EC2メニューのキーペアにて"serverkey"名でSSHセキュリティキー登録すること。

下記のフォルダ内へ順番入り、リソース作成を実施する。

注> リソース作成前にすべての作業フォルダ内の"backend.tf","data.tf"内にある<バケット名>部分を前の手順で設定した名前に変更すること。

* VPC(ネットワーク作成)
* IAM(EC2アクセス用SSMポリシー作成)
* privateEC2(プライベートEC2)
* publicEC2(パブリックEC2)

注> publicEC2については直接外からSSH接続しない場合は作らなくてもよい。

作成後すべてのEC2に対しセッションマネージャから接続できること。

### 作成コマンド

以下のコマンドで作成可能

一度作成できれば最後のコマンドのみでよい。
```bash
terraform init
terraform plan
terraform apply
→　yesを入力する。
```

## 削除方法

作成とは逆の手順で削除する。

以下のコマンドで削除可能

一度作成できれば最後のコマンドのみでよい。
```bash
terraform destroy
```

利用料のかかるNATのみ消したい場合、VPCフォルダで以下のコマンドを実施する。

```bash
terraform apply -var='enable_nat_gateway=false'
```

NAT Gatewayについて、片系(a)でしか作成していないが、両系で作成したい場合以下のコマンドを実施する。

```bash
terraform apply -var='single_nat_gateway=false'
```

## 一部リソースのみの削除手順

```bash
terraform state list
→リソース確認
terraform apply --target="リソース名"
→再作成対象のリソース指定
terraform destroy --target="リソース名"
→削除対象のリソース指定
```

## RDS作成

VPC,IAM,privateEC2作成後に実施する。

log/RDS,RDSの順番に入りDBを作成する。

出力結果からdb_instance_this_addressの内容(エンドポイントアドレス)を控える。

以下のコマンドでRDSパスワード変更を実施する。
```bash
aws rds modify-db-instance \
--db-instance-identifier "awsvpc-db-instance" \
--master-user-password "任意のパスワード"
```

publicEC2に入り、以下のコマンドを入力してログインできることを確認する。
```bash
sudo dnf -y localinstall https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf -y install mysql mysql-community-client

mysql --version

mysql -h [エンドポイントアドレス] -P 3306 -u awsvpc -p

前の手順で指定したRDSパスワードを入力する。
```

使用しないときはRDSフォルダの中に入り削除すること。

RDSについて、シングル構成にしているが、マルチAZ構成にしたい際は以下の変更を実施する。

```bash
vi RDS/db_instance.tf

以下の部分を書き換える
変更前> multi_az = false
変更後> multi_az = true
```

## ALB作成

上記のソース作成後に実施すること。

予め、ドメイン取得とRoute53へのゾーン登録を実施すること。

以下のファイル内のドメイン名設定を実施する。

```bash
vi main/alb/route53.tf
vi main/alb/acm.tf
name = "<ドメイン名>"部分を書き換える。
```

”log/RDS/s3.tf”内の<バケット名>部分を適当な名前に変更する。

publicEC2で以下のコマンドでhttpdを立ち上げる。

```bash
sudo yum -y install httpd
sudo service httpd start
sudo chkconfig httpd on
sudo sudo vi /var/www/html/index.html

以下の文字を入れる。
Website
```

log/alb,albの順番に入りALBを作成する。

以下のURLにアクセスし、サイトアクセスできるか確認する。

```bash
https://web.<ドメイン名>/
```

"Website"という文字が表示されること。

利用料のかかるALBのみ消したい場合、albフォルダで以下のコマンドを実施する。

```bash
terraform apply -var='enable_nat_alb=false'
```

## ElastiCache(Redis)作成

VPC,IAM,privateEC2作成後に実施する。

CACHEに入りcacheを作成する。

出力結果からelasticache_replication_group_this_primary_endpoint_addressの

内容(エンドポイントアドレス)を控える。

privateEC2の再起動を行う。

elasticache_replication_group_this_primary_endpoint_address

```bash
sudo yum -y install nc

(echo ping;sleep 1) | nc [エンドポイントアドレス] 6379

”＋PONG”が返ってくること。
```

## RDS/CACHE用CNAME（db．awsvpc．internal/cache.awsvpc.internal）作成

VPC/IAM/PrivateEC2/RDS/CACHEを作成していること。

CNAMEに入り、リソースを作成する。

publicEC2に入り、以下のコマンドを入力してログインできることを確認する。
```bash
mysql -h db.awsvpc.internal -P 3306 -u awsvpc -p

RDS設定で指定したRDSパスワードを入力する。

(echo ping;sleep 1) | nc cache.awsvpc.internal 6379

”＋PONG”が返ってくること。
```

名前が引けない場合、EC2を再起動してリトライすること。

## リソース情報抜き出し(terraform1.5以降で実施)

参考URL:

https://zenn.dev/ryoyoshii/articles/81a7cfc7140816

privateEC2作成後に実施

pri_vm01のインスタンスIDを確認する。コンソールまたは作成後のprivate_ec2_1_idの値を控える。

ソースファイル編集する。

```bash
vi import.tf

以下の日本語部分をIDに書き換える。

import {
  id = "<EC2リソースのID>"
  to = aws_instance.source
}
```

以下のコマンドを入力してファイル出力する。

```bash
terraform init
terraform plan -generate-config-out=generated.tf
```

generated.tf内にプライベートEC2のリソースコードが出力されていることを確認する。

＊エラーについては無視してよい。

再使用する際は以下の加工を実施する。

```bash
ipv6_addressesについて、頭に#をつけてマスクする。

最後に以下記載を追記する(インポートしたリソースを誤って操作してしまわないようにおまじない)
  lifecycle {
    ignore_changes = all
  }
```

更に、プライベートIP,タグ名を書き換えてimport.tfの内容をすべてマスクしてplan/applyをするとEC2の追加が行える。

TシリーズEC2についてはcpu_options部分もマスクしてください。

他のリソースについては以下のページから確認できます。

import.tfの内容を追記することにより別の取り出しできます。

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

既存リソースから情報を取り出し対象のtfstateへ登録したい際は上記の加工を実施の上、
適当なリソースフォルダに入れ、applyコマンド入れれば登録できます。

手動作成したリソースをterraformへ登録したい場合にも利用できます。
