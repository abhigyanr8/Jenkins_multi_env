variable "MSK_CLUSTER_CONFIG_NAME" {
  type        = string
  description = "MSK cluster configuration name"
}

variable "MSK_CLUSTER_SECURITY_GROUPS" {}

variable "MSK_SERVER_PROPERTIES" {
  type = object({
    AUTO_CREATE_TOPICS_ENABLE = bool
    DELETE_TOPIC_ENABLE       = bool
    REPLICATION_FACTOR        = number
    MINIMUM_INSYNC_REPLICAS   = number
    PARTITION_NUMBER          = number
    LOG_RETENTION_HOURS       = number
  })
}

variable "CLOUD_WATCH_LOG_PROPERTIES" {
  type = object({
    MSK_LOG_GROUP_NAME        = string
    MSK_LOG_RETENTION_IN_DAYS = number
  })
}

variable "MSK_CLUSTER_PROPERTIES" {
  type = object({
    MSK_CLUSTER_NAME             = string
    KAFKA_VERSION                = string
    MSK_NUMBER_OF_BROKER_NODES   = number
    MSK_ENHANCED_MONITORING      = string
    MSK_BROKER_INSTANCE_TYPE     = string
    MSK_EBS_STORAGE_VOLUME       = number
    MSK_CLIENT_BROKER_ENCRYPTION = string
    MSK_CLIENT_SUBNETS           = list(string)
    MSK_CLSTER_TAG               = map(string)
  })
}

variable "MSK_TOPIC_PROPERTIES" {
  type = object({
    TOPIC_NAME                  = string
    TOPIC_REPLICATION_FACTOR    = number
    TOPIC_PARTITIONS            = number
    TOPIC_CONFIG_SEGMENT_MS     = number
    TOPIC_CONFIG_CLEANUP_POLICY = string
  })
}

