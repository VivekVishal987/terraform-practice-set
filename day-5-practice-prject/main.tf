resource "aws_key_pair" "example" {
    key_name = "my-prv-key"
    public_key = file("~/.ssh/id_rsa.pub")
  
}


resource "aws_instance" "dev" {
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type = "t2.micro"
  key_name = aws_key_pair.example.key_name

    tags = {
        Name = "Myec2-instance-1"
    } 

   connection {
      type = "ssh"
      user = "ec2-user"
      private_key =  file("~/.ssh/id_rsa")
      host        =  self.public_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "touch file200",
            "echo hello from aws >> file200",
         ]
    }
}


