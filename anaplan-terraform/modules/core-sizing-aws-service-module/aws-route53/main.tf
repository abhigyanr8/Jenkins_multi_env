#Route53 resource of core-sizing load balancer
resource "aws_route53_record" "zone-record-to-core-sizing-lb" {
  zone_id = var.ROUTE53_ANAPLAN_IO_ZONE_ID
  name    = "${var.CORE_SIZING_LAMBDA_SUBDOMAIN_NAME}.${var.NIBS_ACCOUNT_ANAPLAN_IO_DNS_NAME}"
  type    = "A"

  alias {
    name                   = var.CORE_SIZING_LOAD_BALANCER.dns_name
    zone_id                = var.CORE_SIZING_LOAD_BALANCER.zone_id
    evaluate_target_health = true
  }
}

#Route53 resource of MSK cluster load balancer
resource "aws_route53_record" "zone-record-to-msk-lb" {
  zone_id = var.ROUTE53_ANAPLAN_IO_ZONE_ID
  name    = "${var.MSK_BROKER_SUBDOMIAN_NAME}.${var.NIBS_ACCOUNT_ANAPLAN_IO_DNS_NAME}"
  type    = "A"

  alias {
    name                   = var.MSK_CLUSTER_LOAD_BALANCER.dns_name
    zone_id                = var.MSK_CLUSTER_LOAD_BALANCER.zone_id
    evaluate_target_health = true
  }
}
