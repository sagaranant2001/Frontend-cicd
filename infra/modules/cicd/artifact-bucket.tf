resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.project_name}-pipeline-artifacts"
  force_destroy = true
}

resource "aws_s3_bucket" "source" {
  bucket        = "${var.project_name}-pipeline-source"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id

  versioning_configuration {
    status = "Enabled"
  }
}