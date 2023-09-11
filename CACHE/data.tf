data "terraform_remote_state" "network_main" {
  backend = "s3"

  config = {
    bucket = "terraform-state-naritomo"
    key    = "VPC/VPC.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "private_ec2" {
  backend = "s3"

  config = {
    bucket = "terraform-state-naritomo"
    key    = "privateEC2/privateEC2.tfstate"
    region = "ap-northeast-1"
  }
}