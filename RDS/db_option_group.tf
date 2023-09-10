# オプショングループ作成

resource "aws_db_option_group" "this" {
  name = "awsvpc-db-option"

  engine_name          = "mysql"
  major_engine_version = "8.0"

  tags = {
    Name = "awsvpc-db-option"
  }
}