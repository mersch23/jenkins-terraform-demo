resource "aws_s3_bucket" "louise" {
  bucket = "louise-bucket-1234567890"

  tags = {
    Name        = "Louise Bucket"
    Environment = "Dev"
  }
}
