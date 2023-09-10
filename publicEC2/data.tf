data "terraform_remote_state" "network_main" {
  backend = "s3"

  config = {
    bucket = "terraform-state-naritomo"
    key    = "VPC/VPC.tfstate"
    region = "ap-northeast-1"
  }
}
