# General 
variable "AWS_REGION" {}
variable "AWS_PROFILE" {}

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
    sg_name          = replace(local.raw_locals.msk.sg_name, "<env>", local.tags.Environment)
    msk_name         = replace(local.raw_locals.msk.msk_name, "<env>", terraform.workspace)
    event_topic_name = replace(local.raw_locals.msk.event_topic_name, "<env>", terraform.workspace)
  }

  crs = {
    sg_name = replace(local.raw_locals.crs.sg_name, "<env>", local.tags.Environment)

    iam_lambda_role_name                = replace(local.raw_locals.crs.iam.lambda_role_name, "<env>", local.tags.Environment)
    iam_lambda_perm_policy_name         = replace(local.raw_locals.crs.iam.lambda_perm_policy_name, "<env>", local.tags.Environment)
    iam_lambda_persist_role_name        = replace(local.raw_locals.crs.iam.lambda_persist_role_name, "<env>", local.tags.Environment)
    iam_lambda_persist_perm_policy_name = replace(local.raw_locals.crs.iam.lambda_persist_perm_policy_name, "<env>", local.tags.Environment)
    iam_lambda_log_role_name            = replace(local.raw_locals.crs.iam.lambda_log_role_name, "<env>", local.tags.Environment)

    cwatch_sizing_promtail_filter_name    = replace(local.raw_locals.crs.cwatch.sizing_promtail_filter_name, "<env>", local.tags.Environment)
    cwatch_persister_promtail_filter_name = replace(local.raw_locals.crs.cwatch.persister_promtail_filter_name, "<env>", local.tags.Environment)

    s3_core_sizing_msk_code_repo               = replace(local.raw_locals.crs.s3.core_sizing_msk_code_repo, "<env>", local.tags.Environment)
    core_sizing_lambda_code_jar_name           = "core-sizing-lambda-${var.CORE_SIZING_VERSION}.jar"
    core_memory_persister_lambda_code_jar_name = "core-memory-persister-${var.CORE_SIZING_VERSION}.jar"

    core_sizing_lambda_fun_name          = replace(local.raw_locals.crs.lambda.core_sizing_lambda_fun_name, "<env>", local.tags.Environment)
    core_sizing_lambda_alias_name        = replace(local.raw_locals.crs.lambda.core_sizing_lambda_alias_name, "<env>", local.tags.Environment)
    core_sizing_lambda_otel_service_name = replace(local.raw_locals.crs.lambda.core_sizing_lambda_otel_service_name, "<env>", local.tags.Environment)
    lambda_otel_java_lambda_layer_arn    = "arn:aws:lambda:${var.AWS_REGION}:901920570463:layer:aws-otel-java-agent-amd64-ver-1-28-1:1"

    core_sizing_msk_lambda_persister_name              = replace(local.raw_locals.crs.lambda.core_sizing_msk_lambda_persister_name, "<env>", local.tags.Environment)
    core_sizing_msk_lambda_persister_otel_service_name = replace(local.raw_locals.crs.lambda.core_sizing_msk_lambda_persister_otel_service_name, "<env>", local.tags.Environment)
    core_sizing_msk_lambda_persister_alias_name        = replace(local.raw_locals.crs.lambda.core_sizing_msk_lambda_persister_alias_name, "<env>", local.tags.Environment)

    core_sizing_lb_name                  = replace(local.raw_locals.crs.loadbalancer.core_sizing_lb_name, "<env>", local.tags.Environment)
    core_sizing_lb_target_group_name     = replace(local.raw_locals.crs.loadbalancer.core_sizing_lb_target_group_name, "<env>", local.tags.Environment)
    core_sizing_msk_lb_name              = replace(local.raw_locals.crs.loadbalancer.core_sizing_msk_lb_name, "<env>", local.tags.Environment)
    core_sizing_msk_lb_target_group_name = replace(local.raw_locals.crs.loadbalancer.core_sizing_msk_lb_target_group_name, "<env>", local.tags.Environment)
  }

  lpath = {
    core_sizing_lambda_code_jar_path           = "${var.LAMBDAS_CODE_JAR_PATH}/${local.crs.core_sizing_lambda_code_jar_name}"
    core_memory_persister_lambda_code_jar_path = "${var.LAMBDAS_CODE_JAR_PATH}/${local.crs.core_memory_persister_lambda_code_jar_name}"
  }
}
## >>------------|> Core-Sizing Service Module Variables <|------------<< ##

#Labda Jar file resource
variable "CORE_SIZING_VERSION" {}
variable "LAMBDAS_CODE_JAR_PATH" {
  type        = string
  default     = "resources"
  description = "path of repo where code of lambda will reside"
}

variable "NIBS_ACCOUNT_ANAPLAN_IO_DNS_NAME" {
  default = "ap-nibs-sizing-np.anaplan.io"
}

variable "CORE_SIZING_LAMBDA_SUBDOMAIN_NAME" {
  default = "core-sizing.lambda"
}

variable "MSK_BROKER_SUBDOMIAN_NAME" {
  default = "msk.brokers"
}
