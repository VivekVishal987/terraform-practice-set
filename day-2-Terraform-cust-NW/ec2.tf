resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance-type
  key_name = var.keyname
  subnet_id = aws_subnet.dev.id
  vpc_security_group_ids =  [ aws_security_group.dev.id ]
    tags = {
        Name = "Myec2-instance-practice"
    }           
}
