# ====================
#
# Elastic IP
#
# ====================
resource "aws_eip" "eip_1" {
  instance = aws_instance.aws_ec2_1.id
  vpc      = true
}

resource "aws_eip" "eip_2" {
  instance = aws_instance.aws_ec2_2.id
  vpc      = true
}
