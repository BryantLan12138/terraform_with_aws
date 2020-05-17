resource "aws_db_subnet_group" "a2" {
  name       = "a2"
  subnet_ids = [aws_subnet.Data_az1.id, aws_subnet.Data_az2.id, aws_subnet.Data_az3.id]

  tags = {
    Name = "My DB subnet group for A2"
  }
}

resource "aws_security_group" "attach_db" {
  description = "To Allow traffic from ec2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "traffic from ec2"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-db"
  }
}


resource "aws_db_instance" "postgresql" {
  identifier             = "app-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6"
  instance_class         = "db.t2.micro"
  name                   = "A2_DB"
  username               = "Assignment2"
  password               = "isnothard"
  parameter_group_name   = "default.postgres9.6"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.a2.id
  vpc_security_group_ids = [aws_security_group.attach_db.id]
  port                   = 5432

  #   security_group_names = [aws_security_group.allow_http_ssh.id]
  #   vpc_id               = aws_vpc.main.id
  #   subnet_ids           = aws_subnet.Data_az1.id
}

// to do the remote backend 

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "tu-lan-sdo-assignment2"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tu-lan-sdo-assignment2"
    key = "file/terraform.tfstate"
    region = "us-east-1"
  }
}


// create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb_table_to_store_state" {
  name           = "to_store_terraform_state_tu_lan"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}


terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "tu-lan-sdo-assignment2"
    region         = "us-east-1"
    dynamodb_table = "to_store_terraform_state_tu_lan"
    key            = "file/terraform.tfstate"
  }
} 