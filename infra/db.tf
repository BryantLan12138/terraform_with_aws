resource "aws_db_subnet_group" "a2" {
  name       = "a2"
  subnet_ids = [aws_subnet.Data_az1.id, aws_subnet.Data_az2.id, aws_subnet.Data_az3.id]

  tags = {
    Name = "My DB subnet group for A2"
  }
}

resource "aws_db_instance" "postgresql" {
  identifier           = "app-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.6"
  instance_class       = "db.t2.micro"
  name                 = "A2_DB"
  username             = "Assignment2"
  password             = "isnothard"
  parameter_group_name = "default.postgres9.6"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.a2.id
  port                 = 5432

  #   security_group_names = [aws_security_group.allow_http_ssh.id]
  #   vpc_id               = aws_vpc.main.id
  #   subnet_ids           = aws_subnet.Data_az1.id
}