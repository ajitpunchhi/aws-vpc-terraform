# resource "aws_s3_bucket" "updatedbucket" {
#   bucket = "my-sandbox-bucket-${var.aws_region}"
#   tags = {
#     Name        = "My Sandbox Bucket"
#     Environment = "Sandbox"
#     CreatedBy   = "Terraform"
#     Project     = "Infrastructure"
#     Owner       = "DevOps Team"
#   }
# }

# resource "aws_s3_bucket_versioning" "name" {
  
#   bucket = aws_s3_bucket.updatedbucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }