# VPCID出力

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

# subnet情報出力

output "subnet_public" {
  value = aws_subnet.public
}

output "subnet_private" {
  value = aws_subnet.private
}

# SubnetID出力(EC2用)

output "subnet_publica_id" {
  value = aws_subnet.public["a"].id
}

output "subnet_publicc_id" {
  value = aws_subnet.public["c"].id
}

output "subnet_privatea_id" {
  value = aws_subnet.private["a"].id
}

output "subnet_privatec_id" {
  value = aws_subnet.private["c"].id
}

# ALB用SG出力

output "security_group_web_id" {
  value = aws_security_group.web.id
}

# DB用サブネット出力

output "db_subnet_group_this_id" {
  value = aws_db_subnet_group.this.id
}

## cache用サブネットグループ出力

output "elasticache_subnet_group_this_name" {
  value = aws_elasticache_subnet_group.this.name
}
