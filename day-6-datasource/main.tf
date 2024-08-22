data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

data "aws_subnet" "dev" {
  filter {
    name   = "tag:Name"
    values = ["default"]  # Replace with your tag value
  }
}

resource "aws_instance" "dev" {
    ami = data.aws_ami.amzlinux.id
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    subnet_id = data.aws_subnet.dev.id
    tags = {
        Name = "my-server"
    }
}