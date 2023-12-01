variable "GLUE_PROPERTIES" {
  type = object({
    GLUE_REGISTRY_NAME = string
    GLUE_SCHEMA_NAME   = string
    GLUE_TAG           = map(string)
  })
}
