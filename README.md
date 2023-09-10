# terraform_main_source

## 立ち上げ概要

AWSの2つのAZにてパブリック/プライベートSubnetを作成しており、

すべてのサブネットでSSMで入れるサーバが４台稼働。

パブリックはNAT GatewayでEC2からの外部接続可能。

パブリックEC2からはALBに接続されており、SSLで外部からのWebサイトアクセス可能。

RDSについてはプライベートEC2から接続可能とする。

## 前提

以下のページなどを参考に、terraform稼働環境を作成し、AWSでの適当なリソースが作成できる状態にあること。

[Terraformをdocker環境で立ち上げてみる。](https://qiita.com/naritomo08/items/7e5a9d1b7eaf18dc0060)

## terraformソースファイル入手

terraformを動かすフォルダ内にて、以下コマンドを稼働する。

```bash
git clone git@github.com:naritomo08/terraform_main_source.git
cd terraform_main_source
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

注> リソース作成前にすべての作業フォルダ内の"backend.tf"内にある<バケット名>部分を前の手順で設定した名前に変更すること。

* VPC(ネットワーク作成),IAM,privateEC2,publicEC2
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

前の手順で指定したパスワードを入力する。
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
