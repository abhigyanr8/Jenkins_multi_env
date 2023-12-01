output "TIMESTREAM_DB" {
  value = "${terraform.workspace}-CoreMemory"
}
output "TIMESTREAM_TBL" {
  value = "${terraform.workspace}-ModelMemory"
}