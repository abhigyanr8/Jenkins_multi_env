## >>---------------|> Core-Sizing Infrastructure Modules <|----------------<< ##

# Module - Infra - Time Stream DataBase
module "core-sizing-infra-tsdb" {
  source = "../modules/core-sizing-aws-infra-module/aws-time-stream-db"
  INFRA_TSB_VARIABLES = {
    TIMESTREAM_DB_NAME                      = local.tsb.db_name
    TIMESTREAM_TBL_NAME                     = local.tsb.tbl_name
    MAGNETIC_STORE_RETENTION_PERIOD_IN_DAYS = var.INFRA_TSB_VARIABLES.MAGNETIC_STORE_RETENTION_PERIOD_IN_DAYS
    MEMORY_STORE_RETENTION_PERIOD_IN_HOURS  = var.INFRA_TSB_VARIABLES.MEMORY_STORE_RETENTION_PERIOD_IN_HOURS
    TAGS_DB                                 = local.tags
  }
}

# Module - Infra - Security Groups
module "core-sizing-infra-sg" {
  source = "../modules/core-sizing-aws-infra-module/aws-security-group"
  # MSK Security Group Properties
  MSK_CLUSTER_SG_PROPERTIES = {
    SECURITY_GROUP_NAME   = local.msk.sg_name
    SECURITY_GROUP_VPC_ID = var.NETWORK_INFORMATION.VPC_ID
    SECURITY_GROUP_TAG    = local.tags
  }
  MANAGED_PREFIX_ID_LIST = [data.aws_ec2_managed_prefix_list.anplan_vpn.id]
}

# Module - Infra - MSK Cluster
module "core-sizing-infra-msk" {
  source                  = "../modules/core-sizing-aws-infra-module/aws-msk"
  MSK_CLUSTER_CONFIG_NAME = local.msk.conf_name
  #MSK Server Properties
  MSK_SERVER_PROPERTIES = {
    AUTO_CREATE_TOPICS_ENABLE = var.INFRA_MSK_CLUSTER_VARIABLE.AUTO_CREATE_TOPICS_ENABLE
    DELETE_TOPIC_ENABLE       = var.INFRA_MSK_CLUSTER_VARIABLE.DELETE_TOPIC_ENABLE
    REPLICATION_FACTOR        = var.INFRA_MSK_CLUSTER_VARIABLE.REPLICATION_FACTOR
    MINIMUM_INSYNC_REPLICAS   = var.INFRA_MSK_CLUSTER_VARIABLE.MINIMUM_INSYNC_REPLICAS
    PARTITION_NUMBER          = var.INFRA_MSK_CLUSTER_VARIABLE.PARTITION_NUMBER
    LOG_RETENTION_HOURS       = var.INFRA_MSK_CLUSTER_VARIABLE.LOG_RETENTION_HOURS
  }
  #Cloud Watch log Properties
  CLOUD_WATCH_LOG_PROPERTIES = {
    MSK_LOG_GROUP_NAME        = local.msk.log_gp_name
    MSK_LOG_RETENTION_IN_DAYS = var.INFRA_MSK_CLUSTER_VARIABLE.MSK_LOG_RETENTION_IN_DAYS
  }
  #MSK Cluster Security Group
  MSK_CLUSTER_SECURITY_GROUPS = module.core-sizing-infra-sg.msk_security_group_id
  #MSK Cluster Properties
  MSK_CLUSTER_PROPERTIES = {
    MSK_CLUSTER_NAME             = local.msk.msk_name
    MSK_CLSTER_TAG               = local.tags
    KAFKA_VERSION                = "3.4.0"
    MSK_NUMBER_OF_BROKER_NODES   = var.INFRA_MSK_CLUSTER_VARIABLE.MSK_NUMBER_OF_BROKER_NODES
    MSK_ENHANCED_MONITORING      = var.INFRA_MSK_CLUSTER_VARIABLE.MSK_ENHANCED_MONITORING
    MSK_BROKER_INSTANCE_TYPE     = var.INFRA_MSK_CLUSTER_VARIABLE.MSK_BROKER_INSTANCE_TYPE
    MSK_EBS_STORAGE_VOLUME       = var.INFRA_MSK_CLUSTER_VARIABLE.MSK_EBS_STORAGE_VOLUME
    MSK_CLIENT_BROKER_ENCRYPTION = var.INFRA_MSK_CLUSTER_VARIABLE.MSK_CLIENT_BROKER_ENCRYPTION
    MSK_CLIENT_SUBNETS           = var.NETWORK_INFORMATION.PRIVATE_SUBNET_IDS
  }
  #MSK Topic Propertes
  MSK_TOPIC_PROPERTIES = {
    TOPIC_NAME                  = local.msk.event_topic_name
    TOPIC_REPLICATION_FACTOR    = var.INFRA_KAFKA_TOPIC_VARIABLE.TOPIC_REPLICATION_FACTOR
    TOPIC_PARTITIONS            = var.INFRA_KAFKA_TOPIC_VARIABLE.TOPIC_PARTITIONS
    TOPIC_CONFIG_SEGMENT_MS     = var.INFRA_KAFKA_TOPIC_VARIABLE.TOPIC_CONFIG_SEGMENT_MS
    TOPIC_CONFIG_CLEANUP_POLICY = var.INFRA_KAFKA_TOPIC_VARIABLE.TOPIC_CONFIG_CLEANUP_POLICY
  }
}

#Glue Module
module "core-sizing-infra-glue" {
  source = "../modules/core-sizing-aws-infra-module/aws-glue"
  GLUE_PROPERTIES = {
    GLUE_REGISTRY_NAME = local.glue.registry_name
    GLUE_SCHEMA_NAME   = local.glue.schema_name
    GLUE_TAG           = local.tags
  }
}
