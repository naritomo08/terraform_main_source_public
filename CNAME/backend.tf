# ftstateをバケットに保管する。
terraform {
  backend "s3" {
    bucket  = "terraform-state-naritomo"
    region  = "ap-northeast-1"
    key     = "cname/cname.tfstate"
    encrypt = true
    dynamodb_table = "terraform_state_lock_naritomo"
  }
}
