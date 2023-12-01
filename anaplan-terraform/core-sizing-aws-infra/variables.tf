# General 
variable "AWS_REGION" {}
variable "AWS_PROFILE" {}

# Module local variables 
locals {
  raw_locals = yamldecode(file("${path.module}/../variables.yaml"))
  tags = {
    createdBy   = "Anaplan-CoreSizing-Team"
    CreatedOn   = timestamp()
    Environment = terraform.workspace
  }
  tsb = {
    db_name  = replace(local.raw_locals.tsb.db_name, "<env>", terraform.workspace)
    tbl_name = replace(local.raw_locals.tsb.tbl_name, "<env>", terraform.workspace)
  }
  msk = {
    sg_name          = replace(local.raw_locals.msk.sg_name, "<env>", terraform.workspace)
    conf_name        = replace(local.raw_locals.msk.conf_name, "<env>", terraform.workspace)
    log_gp_name      = replace(local.raw_locals.msk.log_gp_name, "<env>", terraform.workspace)
    msk_name         = replace(local.raw_locals.msk.msk_name, "<env>", terraform.workspace)
    event_topic_name = replace(local.raw_locals.msk.event_topic_name, "<env>", terraform.workspace)
  }
  glue = {
    registry_name = replace(local.raw_locals.glue.registry_name, "<env>", terraform.workspace)
    schema_name   = replace(local.raw_locals.glue.schema_name, "<env>", terraform.workspace)
  }
}

#Managed prefix list
variable "MANAGED_PREFIX_LIST_NAME" {
  description = "The name of the prefix list that is allowed to connect to our AWS components."
}

#Network
variable "NETWORK_INFORMATION" {
  type = object({
    VPC_ID             = string
    PRIVATE_SUBNET_IDS = list(string)
    PUBLIC_SUBNET_IDS  = list(string)
  })
}

## >>------------|> Core-Sizing Infrastructure Module Variables <|-----------<< ##

#Time Stream DB variable
variable "INFRA_TSB_VARIABLES" {
  type = object({
    MAGNETIC_STORE_RETENTION_PERIOD_IN_DAYS = number
    MEMORY_STORE_RETENTION_PERIOD_IN_HOURS  = number
  })
}

#MSK Cluster variable
variable "INFRA_MSK_CLUSTER_VARIABLE" {
  type = object({
    AUTO_CREATE_TOPICS_ENABLE    = bool
    DELETE_TOPIC_ENABLE          = bool
    REPLICATION_FACTOR           = number
    MINIMUM_INSYNC_REPLICAS      = number
    PARTITION_NUMBER             = number
    LOG_RETENTION_HOURS          = number
    MSK_LOG_RETENTION_IN_DAYS    = number
    MSK_NUMBER_OF_BROKER_NODES   = number
    MSK_ENHANCED_MONITORING      = string
    MSK_BROKER_INSTANCE_TYPE     = string
    MSK_EBS_STORAGE_VOLUME       = number
    MSK_CLIENT_BROKER_ENCRYPTION = string
  })
}

#Kafka topic variable
variable "INFRA_KAFKA_TOPIC_VARIABLE" {
  type = object({
    TOPIC_REPLICATION_FACTOR    = number
    TOPIC_PARTITIONS            = number
    TOPIC_CONFIG_SEGMENT_MS     = number
    TOPIC_CONFIG_CLEANUP_POLICY = string
  })
}


## >>------------|> Core-Sizing Service Module Variables <|------------<< ##
