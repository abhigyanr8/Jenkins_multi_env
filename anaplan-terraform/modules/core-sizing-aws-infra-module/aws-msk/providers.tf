#Kafka Providers
terraform {
  required_providers {
    kafka = {
      source = "Mongey/kafka"
    }
  }
}

provider "kafka" {
  bootstrap_servers = split(",", aws_msk_cluster.anaplan-msk-cluster.bootstrap_brokers)
  #    ca_cert           = file("../secrets/ca.crt")
  #    client_cert       = file("../secrets/terraform-cert.pem")
  #    client_key        = file("../secrets/terraform.pem")
  tls_enabled = false
}
