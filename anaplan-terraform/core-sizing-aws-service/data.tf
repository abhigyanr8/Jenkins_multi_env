#Get the list of custom managed CIDR blocks
data "aws_ec2_managed_prefix_list" "anplan_vpn" {
  name = var.MANAGED_PREFIX_LIST_NAME
}

#Get MSK cluster name
data "aws_msk_cluster" "anaplan-msk-cluster" {
  cluster_name = local.msk.msk_name
}

#Get the MSK cluster security group
data "aws_security_group" "msk-sg" {
  name = local.msk.sg_name
}

#Get lambda function promtail
data "aws_lambda_function" "promtail" {
  function_name = "lambda-promtail"
}

#Get Anaplan route53 zone
data "aws_route53_zone" "anaplan-io-zone" {
  name         = var.NIBS_ACCOUNT_ANAPLAN_IO_DNS_NAME
  private_zone = true
}

#get MSK Cluster Broker Nodes
data "aws_msk_broker_nodes" "msk-broker-nodes" {
  cluster_arn = data.aws_msk_cluster.anaplan-msk-cluster.arn
}

#Get MSK Cluster Network Interface
data "aws_network_interface" "msk-network-interface" {
  # node_info_list is of type list(object) - converting it to a map of format:
  #   { (string)broker_id, (object)element of list with that broker id }
  # is necessary to iterate over due to Terraform limitations with for loops
  for_each = {
    for ni in data.aws_msk_broker_nodes.msk-broker-nodes.node_info_list :
    ni.broker_id => ni
  }
  id = each.value.attached_eni_id
}

