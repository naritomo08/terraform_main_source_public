# Security Group作成
resource "aws_security_group" "aws_efs_sg" {
  name        = "terraform-aws-efs-sg"
  description = "For EFS"
  vpc_id      = data.terraform_remote_state.network_main.outputs.vpc_id
  tags = {
    Name = "terraform-aws-efs-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [data.terraform_remote_state.private_ec2.outputs.private_ec2_sgid]
  }
}
