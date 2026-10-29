variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "0.0.0.0/0"
  type        = string
}
