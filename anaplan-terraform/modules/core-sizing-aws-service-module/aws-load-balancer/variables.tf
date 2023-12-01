variable "CORE_SIZING_LOAD_BALANCER_PROPERTIES" {
  type = object({
    CORE_SIZING_LB_NAME            = string
    CORE_SIZING_LB_TARGET_GP_NAME  = string
    CORE_SIZING_LB_SECURITY_GP_IDS = any
    CORE_SIZING_LB_SUBNETS         = list(string)
    CORE_SIZING_LAMBDA_FUN_NAME    = string
    CORE_SIZING_LAMBDA_ALIAS_NAME  = string
    CORE_SIZING_LAMBDA_ALIAS_ID    = string
  })
}

variable "CORE_SIZING_LB_REQUEST_METHODS" {
  description = "The request methods to be created on the ALB."
  type        = list(string)
  default     = ["OPTIONS", "GET"]
}

variable "CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES" {
  type = object({
    CORE_SIZING_MSK_LB_NAME           = string
    CORE_SIZING_MSK_LB_TARGET_GP_NAME = string
    CORE_SIZING_MSK_LB_VPC_ID         = string
    CORE_SIZING_MSK_LB_SUBNETS        = list(string)
    CORE_SIZING_MSK_NI_LIST           = any
  })
}
