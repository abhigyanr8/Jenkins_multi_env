output "core_sizing_lambda_code_s3_bucket_id" {
  value = aws_s3_bucket.anaplan-lambda-code-repo.id
}

output "core_sizing_lambda_object_resource_key" {
  value = aws_s3_object.core-sizing-lambda-object-resource.key
}

output "core_sizing_lambda_object_resource_source" {
  value = aws_s3_object.core-sizing-lambda-object-resource.source
}

output "core_sizing_kafka_lambda_code_s3_bucket_id" {
  value = aws_s3_bucket.anaplan-lambda-code-repo.id
}

output "core_sizing_kafka_lambda_object_resource_key" {
  value = aws_s3_object.lambda-object-resource.key
}

output "core_sizing_kafka_lambda_object_resource_source" {
  value = aws_s3_object.lambda-object-resource.source
}