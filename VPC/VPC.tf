#VPCを作成します。
resource "aws_vpc" "main_vpc" {
  cidr_block = "${local.vpc_cidr}"

  tags = {
    Name = "${local.vpc_name}"
  }
}
