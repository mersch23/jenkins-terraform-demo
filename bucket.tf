resource "aws_s3_bucket" "jesus" {
  bucket = "my-jesus-bucket"

  tags = {
    Name        = "My jesus bucket"
    Environment = "Dev"
  }
}
