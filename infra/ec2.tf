resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

resource "aws_security_group" "allow_ssh" {
  description = "To Allow http and ssh access to the ec2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
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
    Name = "sg-ssh"
  }
}

resource "aws_security_group" "allow_http" {
  description = "To Allow http and ssh access to the ec2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
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
    Name = "sg-http"
  }
}

 

# resource "aws_launch_configuration" "linux" {


#   name            = "web_config"
#   image_id        = var.ami_id
#   instance_type   = "t2.micro"
#   security_groups = [aws_security_group.allow_http_ssh.id]

#   key_name = aws_key_pair.deployer.key_name

# }

resource "aws_lb_target_group" "target_group" {
  name     = "A2-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

}

# resource "aws_autoscaling_group" "linux" {
#   name                 = "A2_ASG"
#   launch_configuration = aws_launch_configuration.linux.name
#   min_size             = 1
#   max_size             = 1
#   vpc_zone_identifier  = [aws_subnet.private_az1.id, aws_subnet.private_az2.id, aws_subnet.private_az3.id]
#   target_group_arns    = [aws_lb_target_group.linux.arn]

# }

resource "aws_lb" "load_balancer" {
  name               = "A2lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front-end" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
# resource "aws_network_interface" "interface"{
#   subnet_id     = aws_subnet.private_az1.id, aws_subnet.private_az2.id, aws_subnet.private_az3.id

#   tags = {
#     Name = "primary_network_interface"
#   }
# }

resource "aws_instance" "front-end" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.id]
  subnet_id       = aws_subnet.private_az1.id
  key_name        = aws_key_pair.deployer.key_name



  tags = {
    Name = "A2 for Tu Lan"
  }
}

