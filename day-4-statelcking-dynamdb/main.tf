#creating s3 bucket and dynamo DB for state backend storgae and applying the lock mechanisam for statefile
resource "aws_s3_bucket" "example" {
  bucket = "statelcking-dynam"
  
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-locking-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "dev" {
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type = "t2.micro"
  key_name = "cfn-key-1"
    tags = {
        Name = "Myec2-system"
    }           
}
