# RDS用ログ保管先作成

resource "aws_cloudwatch_log_group" "error" {
  name = "/aws/rds/instance/awsvpc-db-instance/error"

  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "general" {
  name = "/aws/rds/instance/awsvpc-db-instance/general"

  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "slowquery" {
  name = "/aws/rds/instance/awsvpc-db-instance/slowquery"

  retention_in_days = 90
}