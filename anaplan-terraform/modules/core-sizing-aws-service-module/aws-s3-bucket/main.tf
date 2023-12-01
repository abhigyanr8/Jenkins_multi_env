#Core Sizing Lambda code repository
resource "aws_s3_bucket" "anaplan-lambda-code-repo" {
  bucket = var.CRS_S3_BUCKET_PROPERTIES.MSK_CODE_BUCKET_NAME
}

#Core Sizing Lambda Object resource Bucket
resource "aws_s3_object" "core-sizing-lambda-object-resource" {
  bucket = aws_s3_bucket.anaplan-lambda-code-repo.id
  key    = var.CRS_S3_BUCKET_PROPERTIES.CORE_SIZING_LAMBDA_CODE_JAR_NAME
  # This source clause is referencing the local file system of the terraform host
  source = var.CRS_S3_BUCKET_PROPERTIES.CORE_SIZING_LAMBDA_CODE_JAR_PATH
  //etag   = filemd5(var.CRS_S3_BUCKET_PROPERTIES.CORE_SIZING_LAMBDA_CODE_JAR_PATH)
}

#Core Sizing Persister Lambda resource bucket
resource "aws_s3_object" "lambda-object-resource" {
  bucket = aws_s3_bucket.anaplan-lambda-code-repo.id
  key    = var.CRS_S3_BUCKET_PROPERTIES.CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_NAME
  # This source clause is referencing the local file system of the terraform host
  source = var.CRS_S3_BUCKET_PROPERTIES.CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_PATH
  //etag   = filemd5(var.CRS_S3_BUCKET_PROPERTIES.CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_PATH)
}
