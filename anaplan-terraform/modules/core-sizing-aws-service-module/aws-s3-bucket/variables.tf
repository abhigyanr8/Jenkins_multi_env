variable "CRS_S3_BUCKET_PROPERTIES" {
  type = object({
    CORE_SIZING_LAMBDA_CODE_JAR_NAME           = string
    CORE_SIZING_LAMBDA_CODE_JAR_PATH           = string
    CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_NAME = string
    CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_PATH = string
    MSK_CODE_BUCKET_NAME                       = string
  })
}
