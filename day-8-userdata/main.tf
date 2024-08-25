resource "aws_instance" "name" {
    ami = "ami-0ae8f15ae66fe8cda"
    instance_type = "t2.micro"
    key_name = "cfn-key-1"
    user_data = file("userdata.sh")
    tags = {
      Name = "userdata"
    }
}

