terraform {
  backend "s3" {
    bucket = "my-statefile-store"
    key    = "flder1/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo" # DynamoDB table used for state locking, note: first run day-4-bckend resources then day-5-backend config
    encrypt        = true  # Ensures the state is encrypted at rest in S3
  }
}

