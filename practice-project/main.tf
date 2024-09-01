resource "aws_vpc" "dev" {
    cidr_block = var.vpc-cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name= "main-vpc"
    }
}
resource "aws_subnet" "public" {
    count = 2
    vpc_id = aws_vpc.dev.id
    cidr_block =  element(var.public_subnet_cidrs, count.index)
    availability_zone =  element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
      tags = {
    Name = "public-subnet-${count.index + 1}"
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
  count          = length(aws_subnet.public)
  route_table_id = aws_route_table.dev.id
  subnet_id      = aws_subnet.public[count.index].id
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




        

    

  




  


    

