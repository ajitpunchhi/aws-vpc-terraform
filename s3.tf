resource "aws_s3_bucket" "updatedbucket" {
  bucket = "my-sandbox-bucket-${var.aws_region}"
  tags = {
    Name        = "My Sandbox Bucket"
    Environment = "Sandbox"
}
}