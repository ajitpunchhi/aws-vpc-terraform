resource "aws_s3_bucket" "meewbucket" {
  bucket = "my-sandbox-bucket-${var.aws_region}"
  tags = {
    Name        = "My Sandbox Bucket"
    Environment = "Sandbox"
}
}