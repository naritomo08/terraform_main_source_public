locals {
    vpc_cidr = "192.168.0.0/23"
    vpc_name = "awsvpc"
}

variable "azs" {
  type = map(object({
    public_cidr  = string
    private_cidr = string
  }))
  default = {
    a = {
      public_cidr  = "192.168.0.0/25"
      private_cidr = "192.168.1.0/25"
    },
    c = {
      public_cidr  = "192.168.0.128/25"
      private_cidr = "192.168.1.128/25"
    }
  }
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}
