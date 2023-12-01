# Aws Glue Registry
resource "aws_glue_registry" "core-server-schema-registry" {
  registry_name = var.GLUE_PROPERTIES.GLUE_REGISTRY_NAME
  tags          = var.GLUE_PROPERTIES.GLUE_TAG
  description   = "Registry for schemas used by core events"
}

#Aws Glue Schema
# resource "aws_glue_schema" "core-memory-usage-schema" {
#   registry_arn      = aws_glue_registry.core-server-schema-registry.arn
#   schema_name       = var.GLUE_PROPERTIES.GLUE_SCHEMA_NAME
#   data_format       = "AVRO"
#   compatibility     = "BACKWARD"
#   schema_definition = file("../../../../core-memory-kafka-serde/target/avro/MemoryUsageEvent.avsc")
# }
