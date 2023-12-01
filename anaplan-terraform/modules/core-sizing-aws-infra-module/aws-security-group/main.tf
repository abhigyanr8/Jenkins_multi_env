# MSK Cluster Security Group
resource "aws_security_group" "msk-sg" {
  name   = var.MSK_CLUSTER_SG_PROPERTIES.SECURITY_GROUP_NAME
  vpc_id = var.MSK_CLUSTER_SG_PROPERTIES.SECURITY_GROUP_VPC_ID
  tags   = var.MSK_CLUSTER_SG_PROPERTIES.SECURITY_GROUP_TAG
}

resource "aws_security_group_rule" "allow_tls_traffic" {
  type        = "ingress"
  description = "Allow only TLS traffic to our brokers[Allow systems inside Anaplan connect to kafka.]"
  from_port   = 9092
  to_port     = 9092
  protocol    = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  prefix_list_ids   = var.MANAGED_PREFIX_ID_LIST
  security_group_id = aws_security_group.msk-sg.id
}

resource "aws_security_group_rule" "allow_9098_traffic" {
  type        = "ingress"
  description = "Allow traffic only 9098"
  from_port   = 9098
  to_port     = 9098
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.msk-sg.id
}

resource "aws_security_group_rule" "allow_443_traffic" {
  type        = "ingress"
  description = "Lambda talking to AWS STS service"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.msk-sg.id
}

resource "aws_security_group_rule" "allow_23_traffic" {
  type        = "ingress"
  description = "AWS STS service going through NAT gateway for token"
  from_port   = 23
  to_port     = 23
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.msk-sg.id
}

resource "aws_security_group_rule" "allow_53_traffic" {
  type        = "ingress"
  description = ""
  from_port   = 53
  to_port     = 53
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.msk-sg.id
}

resource "aws_security_group_rule" "egress_443_traffic" {
  type        = "egress"
  description = ""
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.msk-sg.id
}

resource "aws_security_group_rule" "egress_lambda_msk" {
  type        = "egress"
  description = "Lambda talking to msk"
  from_port   = 1024
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.msk-sg.id
}
