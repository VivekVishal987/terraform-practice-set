resource "aws_instance" "stage" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    tags = {
        Name = "my-server"
    }
  lifecycle {
    create_before_destroy = true
  }    

}


