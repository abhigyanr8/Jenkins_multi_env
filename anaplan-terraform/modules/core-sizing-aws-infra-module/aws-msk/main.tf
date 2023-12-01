# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "anaplan-msk-log-group" {
  name              = var.CLOUD_WATCH_LOG_PROPERTIES.MSK_LOG_GROUP_NAME
  retention_in_days = var.CLOUD_WATCH_LOG_PROPERTIES.MSK_LOG_RETENTION_IN_DAYS
}

# Aws managed Kafka cluster configuration
resource "aws_msk_configuration" "anaplan-msk-cluster-configurations" {
  name              = var.MSK_CLUSTER_CONFIG_NAME
  server_properties = <<PROPERTIES
         auto.create.topics.enable  = ${var.MSK_SERVER_PROPERTIES.AUTO_CREATE_TOPICS_ENABLE}
         delete.topic.enable        = ${var.MSK_SERVER_PROPERTIES.DELETE_TOPIC_ENABLE}
         default.replication.factor = ${var.MSK_SERVER_PROPERTIES.REPLICATION_FACTOR}
         min.insync.replicas        = ${var.MSK_SERVER_PROPERTIES.MINIMUM_INSYNC_REPLICAS}
         num.partitions             = ${var.MSK_SERVER_PROPERTIES.PARTITION_NUMBER}
         log.retention.hours        = ${var.MSK_SERVER_PROPERTIES.LOG_RETENTION_HOURS}
        PROPERTIES
}

# Aws managed kafka cluster
resource "aws_msk_cluster" "anaplan-msk-cluster" {
  cluster_name           = var.MSK_CLUSTER_PROPERTIES.MSK_CLUSTER_NAME
  kafka_version          = var.MSK_CLUSTER_PROPERTIES.KAFKA_VERSION
  number_of_broker_nodes = var.MSK_CLUSTER_PROPERTIES.MSK_NUMBER_OF_BROKER_NODES
  enhanced_monitoring    = var.MSK_CLUSTER_PROPERTIES.MSK_ENHANCED_MONITORING
  tags                   = var.MSK_CLUSTER_PROPERTIES.MSK_CLSTER_TAG
  broker_node_group_info {
    client_subnets  = var.MSK_CLUSTER_PROPERTIES.MSK_CLIENT_SUBNETS
    instance_type   = var.MSK_CLUSTER_PROPERTIES.MSK_BROKER_INSTANCE_TYPE
    security_groups = [var.MSK_CLUSTER_SECURITY_GROUPS]
    storage_info {
      ebs_storage_info {
        volume_size = var.MSK_CLUSTER_PROPERTIES.MSK_EBS_STORAGE_VOLUME
      }
    }
  }
  encryption_info {
    encryption_in_transit {
      client_broker = var.MSK_CLUSTER_PROPERTIES.MSK_CLIENT_BROKER_ENCRYPTION
      in_cluster    = true
    }
  }
  client_authentication {
    sasl { iam = true }
    unauthenticated = true
  }
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.anaplan-msk-log-group.id
      }
    }
  }
  configuration_info {
    arn      = aws_msk_configuration.anaplan-msk-cluster-configurations.arn
    revision = aws_msk_configuration.anaplan-msk-cluster-configurations.latest_revision
  }
}

#Aws MSK Kafka topic
resource "kafka_topic" "model-event-topic" {
  depends_on         = [aws_msk_cluster.anaplan-msk-cluster, var.MSK_CLUSTER_SECURITY_GROUPS]
  name               = var.MSK_TOPIC_PROPERTIES.TOPIC_NAME
  replication_factor = var.MSK_TOPIC_PROPERTIES.TOPIC_REPLICATION_FACTOR
  partitions         = var.MSK_TOPIC_PROPERTIES.TOPIC_PARTITIONS
  config = {
    "segment.ms"     = "${var.MSK_TOPIC_PROPERTIES.TOPIC_CONFIG_SEGMENT_MS}"
    "cleanup.policy" = "${var.MSK_TOPIC_PROPERTIES.TOPIC_CONFIG_CLEANUP_POLICY}"
  }
}
