resource "aws_s3_bucket" "Jesus" {
  bucket = "my-Jesus-bucket"

  tags = {
    Name        = "My Jesus bucket"
    Environment = "Dev"
  }
}
