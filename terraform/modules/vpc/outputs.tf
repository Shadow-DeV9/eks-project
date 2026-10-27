output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}

output "private_subnet_ids" {
  description = "IDs of both private subnets"

  value = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}
