resource "aws_elasticache_replication_group" "this" {
  engine = "redis"

  // Redis settings
  replication_group_id          = "awsvpc-cache-replivcation"
  description                   = "Session storage for Laravel"
  engine_version                = "6.x"
  port                          = 6379
  parameter_group_name          = aws_elasticache_parameter_group.this.name
  node_type                     = "cache.t3.micro"
  num_cache_clusters            = 2
  multi_az_enabled              = true

  // Advanced Redis settings
  subnet_group_name = data.terraform_remote_state.network_main.outputs.elasticache_subnet_group_this_name

  // Security
  security_group_ids = [
    aws_security_group.cache.id
  ]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  // Backup
  snapshot_retention_limit = 1
  snapshot_window          = "17:00-18:00"

  // Maintenance
  maintenance_window     = "fri:18:00-fri:19:00"
  notification_topic_arn = ""

  // Others
  automatic_failover_enabled = true
  auto_minor_version_upgrade = false

  tags = {
    Name = "awsvpc-cache-replivcation"
  }
}