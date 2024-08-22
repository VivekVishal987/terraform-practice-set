module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type          = "t2.micro"
  key_name               = "cfn-key-1"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
