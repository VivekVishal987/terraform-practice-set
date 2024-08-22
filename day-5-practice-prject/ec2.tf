resource "aws_instance" "dev" {
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type = "t2.micro"
  key_name = "cfn-key-1"
    tags = {
        Name = "Myec2-instance-1"
    }           
}


