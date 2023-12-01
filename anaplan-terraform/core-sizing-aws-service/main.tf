## >>------------------|> Core-Sizing Service Modules <|--------------<< ##

# Module - Service - CRS Security Groups
module "core-sizing-service-lambda-sg" {
  source = "../modules/core-sizing-aws-service-module/aws-security-group"
  # CRS Lambda Security Group Properties
  CRS_SG_PROPERTIES = {
    SECURITY_GROUP_NAME   = local.crs.sg_name
    SECURITY_GROUP_VPC_ID = var.NETWORK_INFORMATION.VPC_ID
    SECURITY_GROUP_TAG    = local.tags
  }
  MANAGED_PREFIX_ID_LIST = [data.aws_ec2_managed_prefix_list.anplan_vpn.id]
}

# Module - Service - CRS S3 Bucket
module "core-sizing-service-s3-bucket" {
  source = "../modules/core-sizing-aws-service-module/aws-s3-bucket"
  CRS_S3_BUCKET_PROPERTIES = {
    CORE_SIZING_LAMBDA_CODE_JAR_NAME           = local.crs.core_sizing_lambda_code_jar_name
    CORE_SIZING_LAMBDA_CODE_JAR_PATH           = local.lpath.core_sizing_lambda_code_jar_path
    CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_NAME = local.crs.core_memory_persister_lambda_code_jar_name
    CORE_MEMORY_PERSISTER_LAMBDA_CODE_JAR_PATH = local.lpath.core_memory_persister_lambda_code_jar_path
    MSK_CODE_BUCKET_NAME                       = local.crs.s3_core_sizing_msk_code_repo
  }
}

# Module - Service - CRS IAM Policy, Role & Policy Permission
module "core-sizing-service-iam-policy-role" {
  source = "../modules/core-sizing-aws-service-module/aws-iam-policy"
  CRS_LAMBDA_IAM_ROLE_POLICY_NAMES = {
    CRS_LAMBDA_IAM_ROLE_NAME                            = local.crs.iam_lambda_role_name
    CRS_MSK_LAMBDA_PERMISSION_POLICY_NAME               = local.crs.iam_lambda_perm_policy_name
    CRS_MSK_MEM_PERSISTER_LAMBDA_IAM_ROLE_NAME          = local.crs.iam_lambda_persist_role_name
    CRS_MSK_MEM_PERSISTER_LAMBDA_PERMISSION_POLICY_NAME = local.crs.iam_lambda_persist_perm_policy_name
    CRS_LAMBDA_LOGGING_IAM_POLICY_NAME                  = local.crs.iam_lambda_log_role_name
  }
}

# Module - Service - CRS Core Sizing Lambda
module "core-sizing-service-lambda" {
  source = "../modules/core-sizing-aws-service-module/aws-lambda"
  CORE_SIZING_LAMBDA_PROPERTIES = {
    CORE_SIZING_LAMBDA_FUN_NAME          = local.crs.core_sizing_lambda_fun_name
    CORE_SIZING_LAMBDA_ALIAS_NAME        = local.crs.core_sizing_lambda_alias_name
    CORE_SIZING_LAMBDA_CODE_JAR_NAME     = local.crs.core_sizing_lambda_code_jar_name
    CORE_SIZING_LAMBDA_OTEL_SERVICE_NAME = local.crs.core_sizing_lambda_otel_service_name
    CORE_SIZING_LAMBDA_OTEL_LAYER_ARN    = local.crs.lambda_otel_java_lambda_layer_arn

    CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_REGION            = var.AWS_REGION
    CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_NAME              = local.crs.core_sizing_msk_lambda_persister_name
    CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_OTEL_SERVICE_NAME = local.crs.core_sizing_msk_lambda_persister_otel_service_name
    CORE_SIZING_MSK_CONSUMER_LAMBDA_PERSISTER_ALIAS_NAME        = local.crs.core_sizing_msk_lambda_persister_alias_name

    CORE_SIZING_LAMBDA_SUBNETS = var.NETWORK_INFORMATION.PRIVATE_SUBNET_IDS

    CORE_SIZING_LAMBDA_TIMESTREAM_DB_NAME   = local.tsb.db_name
    CORE_SIZING_LAMBDA_TIMESTREAM_TBL_NAME  = local.tsb.tbl_name
    CORE_SIZING_LAMBDA_MSK_MODEL_TOPIC_NAME = local.msk.event_topic_name

    CORE_SIZING_LAMBDA_SECURITY_GP_IDS           = module.core-sizing-service-lambda-sg.crs_security_group_id
    CORE_SIZING_LAMBDA_PERSISTER_SECURITY_GP_IDS = data.aws_security_group.msk-sg.id
  }
  CORE_SIZING_LAMBDA_BUCKET_INFORMATION = {
    CRS_LAMBDA_S3_BUCKET_CODE_REPO_ID              = module.core-sizing-service-s3-bucket.core_sizing_lambda_code_s3_bucket_id
    CRS_LAMBDA_S3_OBJECT_RESOURCE_KEY              = module.core-sizing-service-s3-bucket.core_sizing_lambda_object_resource_key
    CRS_LAMBDA_PERSISTER_S3_BUCKET_CODE_REPO_ID    = module.core-sizing-service-s3-bucket.core_sizing_kafka_lambda_code_s3_bucket_id
    CRS_LAMBDA_PERSISTER_S3_OBJECT_RESOURCE_KEY    = module.core-sizing-service-s3-bucket.core_sizing_kafka_lambda_object_resource_key
    CRS_LAMBDA_S3_OBJECT_RESOURCE_SOURCE           = module.core-sizing-service-s3-bucket.core_sizing_lambda_object_resource_source
    CRS_LAMBDA_PERSISTER_S3_OBJECT_RESOURCE_SOURCE = module.core-sizing-service-s3-bucket.core_sizing_kafka_lambda_object_resource_source
  }
  CORE_SIZING_LAMBDA_IAM_ROLE_ARN = {
    CRS_LAMBDA_IAM_ARN           = module.core-sizing-service-iam-policy-role.core_sizing_lambda_role_arn
    CRS_LAMBDA_PERSISTER_IAM_ARN = module.core-sizing-service-iam-policy-role.core_sizing_msk_lambda_persister_role_arn
  }
  CORE_SIZING_LAMBDA_PERSISTER_MSK_CLUSTER = data.aws_msk_cluster.anaplan-msk-cluster
}

# Module - Service - CRS Cloud Watch
module "core-sizing-service-cloud-watch" {
  source = "../modules/core-sizing-aws-service-module/aws-cloud-watch"
  CRS_CLOUD_WATCH_LOG_PROPERTIES = {
    CRS_SIZING_PROMTAIL_FILTER_NAME    = local.crs.cwatch_sizing_promtail_filter_name
    CRS_PERSISTER_PROMTAIL_FILTER_NAME = local.crs.cwatch_persister_promtail_filter_name
    CRS_PROMTAIL_FILTER_DEST_ARN       = data.aws_lambda_function.promtail.arn
    CORE_SIZING_LAMBDA_LOG_GROUP_NAME  = module.core-sizing-service-lambda.core_sizing_lambda_alias_fun_name
    KAFKA_CORE_CONSUMER_LOG_GROUP_NAME = module.core-sizing-service-lambda.kafka_core_memory_persister_lambda
  }
}

# Module - Service - CRS Load Balancer
module "core-sizing-service-load-balancer" {
  source = "../modules/core-sizing-aws-service-module/aws-load-balancer"
  CORE_SIZING_LOAD_BALANCER_PROPERTIES = {
    CORE_SIZING_LB_NAME            = local.crs.core_sizing_lb_name
    CORE_SIZING_LB_TARGET_GP_NAME  = local.crs.core_sizing_lb_target_group_name
    CORE_SIZING_LB_SECURITY_GP_IDS = module.core-sizing-service-lambda-sg.crs_security_group_id
    CORE_SIZING_LB_SUBNETS         = var.NETWORK_INFORMATION.PRIVATE_SUBNET_IDS
    CORE_SIZING_LAMBDA_FUN_NAME    = module.core-sizing-service-lambda.core_sizing_lambda_fun_name
    CORE_SIZING_LAMBDA_ALIAS_NAME  = module.core-sizing-service-lambda.core_sizing_lambda_alias_name
    CORE_SIZING_LAMBDA_ALIAS_ID    = module.core-sizing-service-lambda.core_sizing_lambda_alias_id
  }
  CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES = {
    CORE_SIZING_MSK_LB_NAME           = local.crs.core_sizing_msk_lb_name
    CORE_SIZING_MSK_LB_TARGET_GP_NAME = local.crs.core_sizing_msk_lb_target_group_name
    CORE_SIZING_MSK_LB_VPC_ID         = var.NETWORK_INFORMATION.VPC_ID
    CORE_SIZING_MSK_LB_SUBNETS        = var.NETWORK_INFORMATION.PRIVATE_SUBNET_IDS
    CORE_SIZING_MSK_NI_LIST           = data.aws_network_interface.msk-network-interface
  }
}

# Module - Service - CRS Route53
module "core-sizing-service-route53" {
  source                            = "../modules/core-sizing-aws-service-module/aws-route53"
  NIBS_ACCOUNT_ANAPLAN_IO_DNS_NAME  = var.NIBS_ACCOUNT_ANAPLAN_IO_DNS_NAME
  CORE_SIZING_LAMBDA_SUBDOMAIN_NAME = var.CORE_SIZING_LAMBDA_SUBDOMAIN_NAME
  MSK_BROKER_SUBDOMIAN_NAME         = var.MSK_BROKER_SUBDOMIAN_NAME
  ROUTE53_ANAPLAN_IO_ZONE_ID        = data.aws_route53_zone.anaplan-io-zone.zone_id
  CORE_SIZING_LOAD_BALANCER         = module.core-sizing-service-load-balancer.core_sizing_lb
  MSK_CLUSTER_LOAD_BALANCER         = module.core-sizing-service-load-balancer.aws_lb_msk_lb
}
