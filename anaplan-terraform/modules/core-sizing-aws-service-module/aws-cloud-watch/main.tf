#core sizing lambda log group
resource "aws_cloudwatch_log_group" "core-sizing-lambda-log-group" {
  name              = "/aws/lambda/${var.CRS_CLOUD_WATCH_LOG_PROPERTIES.CORE_SIZING_LAMBDA_LOG_GROUP_NAME}"
  retention_in_days = 14
}

#core sizing service promtail filter
resource "aws_cloudwatch_log_subscription_filter" "sizing-service-promtail-filter" {
  name            = var.CRS_CLOUD_WATCH_LOG_PROPERTIES.CRS_SIZING_PROMTAIL_FILTER_NAME
  log_group_name  = aws_cloudwatch_log_group.core-sizing-lambda-log-group.name
  destination_arn = var.CRS_CLOUD_WATCH_LOG_PROPERTIES.CRS_PROMTAIL_FILTER_DEST_ARN
  filter_pattern  = "" # an empty string denotes "select all"
}

#Kafka core consumer log group
resource "aws_cloudwatch_log_group" "kafka-core-consumer-log-group" {
  name              = "/aws/lambda/${var.CRS_CLOUD_WATCH_LOG_PROPERTIES.KAFKA_CORE_CONSUMER_LOG_GROUP_NAME}"
  retention_in_days = 14
}

#core sizing lambda persister promtail filer
resource "aws_cloudwatch_log_subscription_filter" "persiste-promtail-filter" {
  name            = var.CRS_CLOUD_WATCH_LOG_PROPERTIES.CRS_PERSISTER_PROMTAIL_FILTER_NAME
  log_group_name  = aws_cloudwatch_log_group.kafka-core-consumer-log-group.name
  destination_arn = var.CRS_CLOUD_WATCH_LOG_PROPERTIES.CRS_PROMTAIL_FILTER_DEST_ARN
  filter_pattern  = "" # an empty string denotes "select all"
}
