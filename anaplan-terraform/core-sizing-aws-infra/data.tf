#Get the list of custom managed CIDR blocks
data "aws_ec2_managed_prefix_list" "anplan_vpn" {
  name = var.MANAGED_PREFIX_LIST_NAME
}