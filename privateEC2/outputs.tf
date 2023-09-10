
# 作成したEC2のプライベートIPアドレスを出力
output "priec2_ip1" {
  value = aws_instance.aws_priec2_1.*.private_ip
}

output "priec2_ip2" {
  value = aws_instance.aws_priec2_2.*.private_ip
}

# SGIDを出力

output "private_ec2_sgid" {
  value = aws_security_group.aws_priec2_sg.id
}

# EC2IDを出力

output "private_ec2_1_id" {
  value = aws_instance.aws_priec2_1.id
}

output "private_ec2_2_id" {
  value = aws_instance.aws_priec2_2.id
}



