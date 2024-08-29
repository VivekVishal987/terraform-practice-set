resource "aws_vpc" "dev" {
    cidr_block = var.prject-vpc
    tags = {
      Name= "main-vpc"
    }

}

