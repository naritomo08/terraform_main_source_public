data "terraform_remote_state" "network_main" {
  backend = "s3"

  config = {
    bucket = "terraform-state-naritomo"
    key    = "VPC/VPC.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "cache_foobar" {
  backend = "s3"

  config = {
    bucket = "terraform-state-naritomo"
    key    = "cache/cache.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-state-naritomo"
    key    = "RDS/RDS.tfstate"
    region = "ap-northeast-1"
  }
}

