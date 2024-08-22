resource "aws_s3_bucket" "dev" {
    bucket = "my-statefile-store"
 
}

resource "aws_s3_bucket_versioning" "dev" {
  bucket = aws_s3_bucket.dev.id
  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
  }
}
    