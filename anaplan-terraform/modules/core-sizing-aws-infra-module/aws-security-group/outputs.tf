output "msk_security_group" {
  value = aws_security_group.msk-sg
}

output "msk_security_group_id" {
  value = aws_security_group.msk-sg.id
}