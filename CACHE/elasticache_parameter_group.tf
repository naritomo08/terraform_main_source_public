resource "aws_elasticache_parameter_group" "this" {
  name = "awsvpc-cache-param"

  family = "redis6.x"
}