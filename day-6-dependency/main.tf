resource "aws_instance" "dependency" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    tags = {
        Name = "my-server"
    }
}

resource "aws_s3_bucket" "dependency" {
    bucket = "my-special-bucket-aws-terraform"
    depends_on = [aws_instance.dependency]
  
}

  
