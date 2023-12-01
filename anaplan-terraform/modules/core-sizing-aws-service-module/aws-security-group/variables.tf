variable "CRS_SG_PROPERTIES" {
  type = object({
    SECURITY_GROUP_NAME   = string
    SECURITY_GROUP_VPC_ID = string
    SECURITY_GROUP_TAG    = map(string)
  })
}

variable "MANAGED_PREFIX_ID_LIST" {
  type = list(string)
  description = "The name of the prefix list that is allowed to connect to our AWS components."
}
