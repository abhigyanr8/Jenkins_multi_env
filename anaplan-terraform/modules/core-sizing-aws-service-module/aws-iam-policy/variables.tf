variable "CRS_LAMBDA_IAM_ROLE_POLICY_NAMES" {
  type = object({
    #core sizing lambda iam role policy name
    CRS_LAMBDA_IAM_ROLE_NAME = string
    #msk cluster from lambda function core sizing lambda permission policy name
    CRS_MSK_LAMBDA_PERMISSION_POLICY_NAME = string
    #CRS MSK core memory persister lambda role
    CRS_MSK_MEM_PERSISTER_LAMBDA_IAM_ROLE_NAME = string
    #CRS MSK core memory persister lambda role
    CRS_MSK_MEM_PERSISTER_LAMBDA_PERMISSION_POLICY_NAME = string
    #IAM policy for logging from a lambda
    CRS_LAMBDA_LOGGING_IAM_POLICY_NAME = string
  })
}
