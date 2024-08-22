resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "my-practice-vpc"
    } 
}


resource "aws_subnet" "dev" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "My practice-subnet"
    }
}

resource "aws_internet_gateway" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "my-practice-ig"
    }  
}

resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev.id
    }   
}

resource "aws_route_table_association" "dev" {
    subnet_id = aws_subnet.dev.id
    route_table_id = aws_route_table.dev.id 
}

resource "aws_security_group" "dev" {
    vpc_id = aws_vpc.dev.id
    tags = {
      Name = "my-practice-sg"
    }  
}

resource "aws_vpc_security_group_ingress_rule" "dev" {
    security_group_id = aws_security_group.dev.id
    cidr_ipv4 = aws_vpc.dev.cidr_block
    from_port         = 22
    ip_protocol       = "tcp"
    to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.dev.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



  