# NAT用EIP作成

resource "aws_eip" "nat_gateway" {
  for_each = var.enable_nat_gateway ? local.nat_gateway_azs : {}

  domain = "vpc"

  tags = {
    Name = "${local.vpc_name}-nat-eip-${each.key}"
  }
}

# NAT作成

resource "aws_nat_gateway" "this" {
  for_each = var.enable_nat_gateway ? local.nat_gateway_azs : {}

  allocation_id = aws_eip.nat_gateway[each.key].id

  subnet_id     = aws_subnet.public[each.key].id

    tags = {
    Name = "${local.vpc_name}-nat-${each.key}"
  }
}

# ルートテーブル(private)作成

resource "aws_route_table" "private" {
  for_each = var.azs

  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${local.vpc_name}-private-route-${each.key}"
  }
}

resource "aws_route" "nat_gateway_private" {
  for_each = var.enable_nat_gateway ? var.azs : {}

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[var.single_nat_gateway ? keys(var.azs)[0] : each.key].id
  route_table_id         = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.azs

  route_table_id = aws_route_table.private[each.key].id

  subnet_id      = aws_subnet.private[each.key].id
}
