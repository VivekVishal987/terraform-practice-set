resource "aws_launch_template" "dev" {
    image_id = "ami-0ae8f15ae66fe8cda"
    instance_type = "t2.micro"
    network_interfaces {
        associate_public_ip_address = true                    
        security_groups             = ["sg-0926bacbf0fb67297"]
    }
}
