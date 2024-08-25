resource "aws_key_pair" "example" {
  key_name   = "example-keypair"
  public_key = file("~/.ssh/my_key_pair.pub")  # Path to your public key file

  tags = {
    Name = "example-keypair"
  }
}

resource "aws_instance" "name" {
    ami = "ami-0ae8f15ae66fe8cda"
    instance_type = "t2.micro"
    key_name = aws_key_pair.example.key_name
}
