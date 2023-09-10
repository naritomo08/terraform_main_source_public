# Security Group作成
resource "aws_security_group" "aws_priec2_sg" {
  name        = "terraform-aws-privateec2-sg"
  description = "For EC2 Linux"
  vpc_id      = data.terraform_remote_state.network_main.outputs.vpc_id
  tags = {
    Name = "terraform-aws-privateec2-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [data.terraform_remote_state.network_main.outputs.security_group_web_id]
  }

  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
