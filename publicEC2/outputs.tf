# 別作成したパブリックIP参照
output "eip_ip1" {
  value = aws_eip.eip_1.public_ip
}

output "eip_ip2" {
  value = aws_eip.eip_2.public_ip
}

# 作成したEC2のプライベートIPアドレスを出力
output "priec2_ip1" {
  value = aws_instance.aws_ec2_1.*.private_ip
}

output "priec2_ip2" {
  value = aws_instance.aws_ec2_2.*.private_ip
}

# SGIDを出力

output "public_ec2_sgid" {
  value = aws_security_group.aws_ec2_sg.id
}

# EC2IDを出力

output "public_ec2_1_id" {
  value = aws_instance.aws_ec2_1.id
}

output "public_ec2_2_id" {
  value = aws_instance.aws_ec2_2.id
}
