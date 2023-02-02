#RDS Instance 
resource "aws_db_instance" "database-instance" {
  identifier             = var.database-instance-identifier
  instance_class         = var.db_instance_type
  snapshot_identifier    = data.aws_db_snapshot.database_snapshot.id
  vpc_security_group_ids = [aws_security_group.rds-instance-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  skip_final_snapshot    = true
}

data "aws_db_snapshot" "database_snapshot" {
  db_snapshot_identifier = var.db_snapshot_identifier
  most_recent            = true
  snapshot_type          = "manual"
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "rds_subnet_group"
  subnet_ids  = [aws_subnet.rds_private_az1.id, aws_subnet.rds_private_az2.id]
  description = "Subnet Group"
}

resource "aws_db_parameter_group" "database-parameter-group" {
  name        = "default-mysql8-0"
  family      = "mysql8.0"
  description = "Default for MySQL Parameter Group"

  parameter {
    name  = "time_zone"
    value = "UTC"
  }
}

output "new_host" {
  value = aws_db_instance.database-instance.endpoint
}
