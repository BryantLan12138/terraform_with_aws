output "instance_public_ip" {
  value = aws_instance.front-end.public_ip
}

output "lb_endpoint" {
  value = aws_lb.load_balancer.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.postgresql.address
}

output "db_user" {
  value = aws_db_instance.postgresql.username
}

output "db_pass" {
  value = aws_db_instance.postgresql.password
}

output "db_name" {
  value = aws_db_instance.postgresql.name
}