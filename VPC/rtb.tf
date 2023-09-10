# ---------------------------
# Route table(public)
# ---------------------------
# Route table作成
resource "aws_route_table" "aws_public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }
  tags = {
    Name = "${local.vpc_name}-public-rt"
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "aws_public_rt_associate1a" {
  subnet_id      = aws_subnet.public["a"].id
  route_table_id = aws_route_table.aws_public_rt.id
}

resource "aws_route_table_association" "aws_public_rt_associate1c" {
  subnet_id      = aws_subnet.public["c"].id
  route_table_id = aws_route_table.aws_public_rt.id
}
