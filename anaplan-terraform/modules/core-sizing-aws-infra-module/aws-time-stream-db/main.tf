#create time stream database
resource "aws_timestreamwrite_database" "anaplan-timestream-db" {
  database_name = var.INFRA_TSB_VARIABLES.TIMESTREAM_DB_NAME
  tags          = var.INFRA_TSB_VARIABLES.TAGS_DB
}

#create time stream table
resource "aws_timestreamwrite_table" "timestream-tbl" {
  database_name = aws_timestreamwrite_database.anaplan-timestream-db.database_name
  table_name    = var.INFRA_TSB_VARIABLES.TIMESTREAM_TBL_NAME
  tags          = var.INFRA_TSB_VARIABLES.TAGS_DB

  retention_properties {
    magnetic_store_retention_period_in_days = var.INFRA_TSB_VARIABLES.MAGNETIC_STORE_RETENTION_PERIOD_IN_DAYS
    memory_store_retention_period_in_hours  = var.INFRA_TSB_VARIABLES.MEMORY_STORE_RETENTION_PERIOD_IN_HOURS
  }
}
