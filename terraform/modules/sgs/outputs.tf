output "security_group_id" {
  description = "The ID of the security group created for allowing TLS traffic."
  value       = aws_security_group.allow_tls.id
}
