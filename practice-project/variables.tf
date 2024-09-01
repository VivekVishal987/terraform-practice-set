variable "vpc-cidr" {
    type = string
    default = ""
  
}


variable "instance-type" {
    type = string
    default = "" 
  
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]  # Adjust based on your needs
}
variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1c", "us-east-1d"]  # Adjust based on your region
}
