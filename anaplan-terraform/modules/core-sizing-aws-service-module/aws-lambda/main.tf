resource "aws_lambda_function" "core-sizing-lambda" {
  function_name = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_FUN_NAME
  description   = "Lambda to execute core-sizing"
  s3_bucket     = var.CORE_SIZING_LAMBDA_BUCKET_INFORMATION.CRS_LAMBDA_S3_BUCKET_CODE_REPO_ID
  s3_key        = var.CORE_SIZING_LAMBDA_BUCKET_INFORMATION.CRS_LAMBDA_S3_OBJECT_RESOURCE_KEY # its mean its depended on upload key
  memory_size   = 256
  timeout       = 900
  timeouts {
    create = "30m"
  }

  environment {
    variables = {
      Version                                      = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_CODE_JAR_NAME
      AWS_LAMBDA_EXEC_WRAPPER                      = "/opt/otel-handler"
      OTEL_SERVICE_NAME                            = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_OTEL_SERVICE_NAME
      OTEL_INSTRUMENTATION_COMMON_DEFAULT_ENABLED  = "false"
      OTEL_INSTRUMENTATION_AWS_LAMBDA_ENABLED      = "true"
      OTEL_INSTRUMENTATION_AWS_SDK_ENABLED         = "true"
      OTEL_INSTRUMENTATION_KAFKA_ENABLED           = "false"
      OTEL_INSTRUMENTATION_RUNTIME_METRICS_ENABLED = "true"
      OTEL_INSTRUMENTATION_METHODS_ENABLED         = "false"
      #OTEL_INSTRUMENTATION_HTTP_CLIENT_CAPTURE_REQUEST_HEADERS="traceparent"
      #OTEL_INSTRUMENTATION_HTTP_SERVER_CAPTURE_REQUEST_HEADERS="traceparent"
      OTEL_TRACES_EXPORTER  = "logging"
      OTEL_METRICS_EXPORTER = "logging"
      OTEL_LOGS_EXPORTER    = "logging"
    }
  }

  runtime          = "java17"
  role             = var.CORE_SIZING_LAMBDA_IAM_ROLE_ARN.CRS_LAMBDA_IAM_ARN
  source_code_hash = base64sha256(var.CORE_SIZING_LAMBDA_BUCKET_INFORMATION.CRS_LAMBDA_S3_OBJECT_RESOURCE_SOURCE)
  handler          = "com.anaplan.coresize.CoreSizingRequestHandler"
  publish          = true
  snap_start {
    apply_on = "PublishedVersions"
  }
  vpc_config {
    security_group_ids = [var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_SECURITY_GP_IDS]
    subnet_ids         = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_SUBNETS
  }
  layers = [
    # https://aws-otel.github.io/docs/getting-started/lambda/lambda-java-auto-instr
    var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_OTEL_LAYER_ARN
  ]

}

#core sizing lambda alias
resource "aws_lambda_alias" "sizing-lambda-alias" {
  name             = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_ALIAS_NAME
  description      = "Alias for the core-sizing-lambda for SnapStart"
  function_name    = aws_lambda_function.core-sizing-lambda.function_name
  function_version = aws_lambda_function.core-sizing-lambda.version
}

#Kafka Core Memory Persister lambda
resource "aws_lambda_function" "kafka-core-memory-persister-lambda" {
  function_name = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_NAME
  description   = "Lambda to persist core memory events to Timestream."
  s3_bucket     = var.CORE_SIZING_LAMBDA_BUCKET_INFORMATION.CRS_LAMBDA_PERSISTER_S3_BUCKET_CODE_REPO_ID
  s3_key        = var.CORE_SIZING_LAMBDA_BUCKET_INFORMATION.CRS_LAMBDA_PERSISTER_S3_OBJECT_RESOURCE_KEY
  # TODO: How much memory do we actually need? Looks like we only use 166, so maybe we could
  # Setting 192 --> 256 following some OOM exceptions popping up, might want to go lower later
  memory_size = 256
  timeout     = 900
  timeouts {
    create = "30m"
  }

  environment {
    variables = {
      DatabaseName                                 = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_TIMESTREAM_DB_NAME
      TableName                                    = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_TIMESTREAM_TBL_NAME
      Region                                       = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_REGION
      JAVA_TOOL_OPTIONS                            = "-Dorg.apache.avro.limits.byte.maxLength=2048 -Dorg.apache.avro.limits.string.maxLength=2048"
      AWS_LAMBDA_EXEC_WRAPPER                      = "/opt/otel-handler"
      OTEL_SERVICE_NAME                            = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_OTEL_SERVICE_NAME
      OTEL_INSTRUMENTATION_COMMON_DEFAULT_ENABLED  = "false"
      OTEL_INSTRUMENTATION_AWS_LAMBDA_ENABLED      = "true"
      OTEL_INSTRUMENTATION_AWS_SDK_ENABLED         = "true"
      OTEL_INSTRUMENTATION_KAFKA_ENABLED           = "false"
      OTEL_INSTRUMENTATION_RUNTIME_METRICS_ENABLED = "true"
      OTEL_INSTRUMENTATION_METHODS_ENABLED         = "false"
      OTEL_TRACES_EXPORTER                         = "logging"
      OTEL_METRICS_EXPORTER                        = "logging"
      OTEL_LOGS_EXPORTER                           = "logging"
    }
  }

  runtime          = "java17"
  role             = var.CORE_SIZING_LAMBDA_IAM_ROLE_ARN.CRS_LAMBDA_PERSISTER_IAM_ARN
  source_code_hash = base64sha256(var.CORE_SIZING_LAMBDA_BUCKET_INFORMATION.CRS_LAMBDA_PERSISTER_S3_OBJECT_RESOURCE_SOURCE)
  handler          = "com.anaplan.memory.persist.MemoryEventHandler"
  publish          = true
  snap_start {
    apply_on = "PublishedVersions"
  }
  vpc_config {
    security_group_ids = [var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_PERSISTER_SECURITY_GP_IDS]
    subnet_ids         = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_SUBNETS
  }
  layers = [
    # https://aws-otel.github.io/docs/getting-started/lambda/lambda-java-auto-instr
    var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_OTEL_LAYER_ARN
  ]

}

#kafka Core Memory Persister Lambda Alias
resource "aws_lambda_alias" "kafka-core-memory-persister-lambda-alias" {
  name             = var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_ALIAS_NAME
  description      = "Alias of perister lambda for SnapStart"
  function_name    = aws_lambda_function.kafka-core-memory-persister-lambda.function_name
  function_version = aws_lambda_function.kafka-core-memory-persister-lambda.version
}

#MSK core memory persister lambda trigger
resource "aws_lambda_event_source_mapping" "msk-core-memory-persister-lambda-trigger" {
  depends_on       = [var.CORE_SIZING_LAMBDA_PERSISTER_MSK_CLUSTER]
  event_source_arn = var.CORE_SIZING_LAMBDA_PERSISTER_MSK_CLUSTER.arn
  function_name    = aws_lambda_alias.kafka-core-memory-persister-lambda-alias.arn
  topics           = [var.CORE_SIZING_LAMBDA_PROPERTIES.CORE_SIZING_LAMBDA_MSK_MODEL_TOPIC_NAME]
  # TODO: I think this means read everything - unlikely to be what we want?
  starting_position = "TRIM_HORIZON"
  enabled           = true
}
