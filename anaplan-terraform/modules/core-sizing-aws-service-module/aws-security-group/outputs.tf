output "crs_security_group" {
  value = aws_security_group.core-sizing-lambda-sg
}

output "crs_security_group_id" {
  value = aws_security_group.core-sizing-lambda-sg.id
}