provider "aws" {
  region = "us-west-2"
}

resource "random_id" "my-random-id" {
  byte_length = 8
}
resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-bucket-${random_id.my-random-id.dec}"
  acl    = "private"
  lifecycle_rule {
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}
