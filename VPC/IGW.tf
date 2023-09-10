# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.vpc_name}-igw"
  }
}
