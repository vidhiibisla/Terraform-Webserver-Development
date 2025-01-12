# Add output variables
output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "vpc_id" {
  value = aws_default_vpc.default_vpc.id
}
