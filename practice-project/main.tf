resource "aws_vpc" "dev" {
    cidr_block = var.vpc-cidr
    tags = {
      Name= "main-vpc"
    }
}
resource "aws_subnet" "public" {
    cidr_block = var.subnet-cidr
    vpc_id = aws_vpc.dev.id
    availability_zone = var.availability-zone
    tags = {
      Name = "main-public-subnet"
    }
}

resource "aws_internet_gateway" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "main-ig"
    }
}
resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev.id
    } 
    tags = {
      Name = "main-route-table"
    }

}
resource "aws_route_table_association" "dev" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.dev.id
  
}

resource "aws_security_group" "dev" {
    vpc_id = aws_vpc.dev.id
    ingress = [
      for port in [22, 80, 443, 8080]:{
        description      = "inbound rules"
        from_port        = port
        to_port          = port
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-project"
  }
}

        

    

  




  


    

