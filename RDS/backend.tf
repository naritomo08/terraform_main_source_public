# ftstateをバケットに保管する。
terraform {
  backend "s3" {
    bucket  = "<バケット名>"
    region  = "ap-northeast-1"
    key     = "RDS/RDS.tfstate"
    encrypt = true
    dynamodb_table = "<バケット名>_lock"
  }
}
