output "core_sizing_lambda_role_arn" {
  value = aws_iam_role.core-sizing-lambda-role.arn
}

output "core_sizing_msk_lambda_persister_role_arn" {
  value = aws_iam_role.msk-core-memory-persister-lambda-role.arn
}