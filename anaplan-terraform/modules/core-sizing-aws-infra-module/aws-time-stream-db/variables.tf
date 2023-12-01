#Time Stream DB variable
variable "INFRA_TSB_VARIABLES" {
  type = object({
    TIMESTREAM_DB_NAME                      = string
    TIMESTREAM_TBL_NAME                     = string
    TAGS_DB                                 = map(string)
    MAGNETIC_STORE_RETENTION_PERIOD_IN_DAYS = number
    MEMORY_STORE_RETENTION_PERIOD_IN_HOURS  = number
  })
}