resource "aws_instance" "dev" {
  ami = var.ami_id
  instance_type = var.instance-type
  key_name = var.keyname
    tags = {
        Name = "my-instance-1"
        }           

}

