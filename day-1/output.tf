output "public-ip" {
  value = aws_instance.dev.public_ip
  description = "printing the public ip"
}



