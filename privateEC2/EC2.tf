

# ---------------------------
# EC2
# ---------------------------
# セキュリティキーは既存のものを使用する(事前に登録すること)。
# Amazon Linux 2 の最新版AMIを取得
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2" # x86_64
  # name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2" # ARM
  # name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-minimal-hvm-x86_64-ebs" # Minimal Image (x86_64)
  # name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-minimal-hvm-arm64-ebs" # Minimal Image (ARM)
}

# Amazon Linux 2023 の最新版AMIを取得
data "aws_ssm_parameter" "amzn3_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64" # x86_64
  # name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64" # ARM
  # name = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-6.1-x86_64" # Minimal Image (x86_64)
  # name = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-6.1-arm64" # Minimal Image (ARM)
}

# Ubuntu20.04のAMIを取得
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# EC2作成(自動付与パブリックIPなし)
resource "aws_instance" "aws_priec2_1" {
  # AmazonLinux2
  #ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  # AmazonLinux2023
  ami                         = data.aws_ssm_parameter.amzn3_latest_ami.value
  # Ubuntu20.04
  #ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  availability_zone           = "ap-northeast-1a"
  key_name                    = "serverkey"
  iam_instance_profile = "SSM_apply_profile"
    network_interface {
    network_interface_id = aws_network_interface.ec2_1_network.id
    device_index         = 0
  }
  tags = {
    Name = "pri_vm01"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_instance" "aws_priec2_2" {
  # AmazonLinux2
  #ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  # AmazonLinux2023
  ami                         = data.aws_ssm_parameter.amzn3_latest_ami.value
  # Ubuntu20.04
  #ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  availability_zone           = "ap-northeast-1c"
  key_name                    = "serverkey"
  iam_instance_profile = "SSM_apply_profile"
  network_interface {
    network_interface_id = aws_network_interface.ec2_2_network.id
    device_index         = 0
  }
  tags = {
    Name = "pri_vm02"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_network_interface" "ec2_1_network" {
  subnet_id   = data.terraform_remote_state.network_main.outputs.subnet_privatea_id
  private_ips = ["192.168.1.100"]
  security_groups      = [aws_security_group.aws_priec2_sg.id]

  tags = {
    Name = "primary_network_interface_1"
  }
}

resource "aws_network_interface" "ec2_2_network" {
  subnet_id   = data.terraform_remote_state.network_main.outputs.subnet_privatec_id
  private_ips = ["192.168.1.200"]
  security_groups      = [aws_security_group.aws_priec2_sg.id]

  tags = {
    Name = "primary_network_interface_2"
  }
}