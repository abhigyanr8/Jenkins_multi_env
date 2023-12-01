output "core_sizing_lambda_fun_name" {
  value = aws_lambda_function.core-sizing-lambda.function_name
}

output "core_sizing_lambda_alias_name" {
  value = aws_lambda_alias.sizing-lambda-alias.name
}

output "core_sizing_lambda_alias_id" {
  value = aws_lambda_alias.sizing-lambda-alias.id
}

output "core_sizing_lambda_alias_fun_name" {
  value = aws_lambda_alias.sizing-lambda-alias.function_name
}

output "kafka_core_memory_persister_lambda" {
  value = aws_lambda_function.kafka-core-memory-persister-lambda.function_name
}