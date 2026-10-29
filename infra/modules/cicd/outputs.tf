output "pipeline_name" {
  value = aws_codepipeline.this.name
}

output "codebuild_project_name" {
  value = aws_codebuild_project.this.name
}

output "source_bucket_name" {
  value = aws_s3_bucket.source.bucket
}

output "artifact_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}