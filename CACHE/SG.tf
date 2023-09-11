# CACHE用SG

resource "aws_security_group" "cache" {
  name   = "awsvpc-cache-sg"
  vpc_id = data.terraform_remote_state.network_main.outputs.vpc_id
  
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    security_groups = [data.terraform_remote_state.private_ec2.outputs.private_ec2_sgid]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "awsvpc-cache-sg"
  }
}