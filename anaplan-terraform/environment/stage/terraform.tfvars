# AWS_REGION                              = "us-east-1"
# ENVIRONMENT                             = terraform.workspace
# TIMESTREAM_DB                           = concat(terraform.workspace,"-CoreMemory")
# TIMESTREAM_TBL                          = concat(terraform.workspace,"-ModelMemory")
MAGNETIC_STORE_RETENTION_PERIOD_IN_DAYS = 80
MEMORY_STORE_RETENTION_PERIOD_IN_HOURS  = 10
VPC_ID                                  = "vpc-01b4f4959147146b2"
