#--------------------------------------
# EFSの作成
#----------------------------------------

resource "aws_efs_file_system" "EFS" {

  encrypted  = "true"

  tags = {
    Name = "EFS"
  }
}

#マウントターゲットの作成
//マウントターゲット1a(higa-Public-subnet-1a)
resource "aws_efs_mount_target" "EFS-1a" {
  file_system_id  = aws_efs_file_system.EFS.id
  subnet_id       = data.terraform_remote_state.network_main.outputs.subnet_publica_id
  security_groups = [aws_security_group.aws_efs_sg.id]
}

//マウントターゲット1c(higa-Public-subnet-2c)
resource "aws_efs_mount_target" "EFS-1c" {
  file_system_id  = aws_efs_file_system.EFS.id
  subnet_id       = data.terraform_remote_state.network_main.outputs.subnet_publicc_id
  security_groups = [aws_security_group.aws_efs_sg.id]
}

resource "aws_efs_access_point" "EFSpoint" {
  file_system_id = aws_efs_file_system.EFS.id
}