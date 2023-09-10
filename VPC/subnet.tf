# サブネット追加
resource "aws_subnet" "public" {
  for_each = var.azs

  availability_zone       = "${data.aws_region.current.name}${each.key}"
  cidr_block              = each.value.public_cidr
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main_vpc.id

  tags = {
    Name = "${local.vpc_name}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.azs

  availability_zone       = "${data.aws_region.current.name}${each.key}"
  cidr_block              = each.value.private_cidr
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.main_vpc.id

  tags = {
    Name = "${local.vpc_name}-private-${each.key}"
  }
}

# DBサブネットグループ作成

resource "aws_db_subnet_group" "this" {
  name = "${local.vpc_name}-db-subnet"

  subnet_ids = [
    for s in aws_subnet.private : s.id
  ]

  tags = {
    Name = "${local.vpc_name}-db-subnet"
  }
}
