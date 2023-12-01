# Core-Sizing Service Lambda Security Group
resource "aws_security_group" "core-sizing-lambda-sg" {
  name   = var.CRS_SG_PROPERTIES.SECURITY_GROUP_NAME
  vpc_id = var.CRS_SG_PROPERTIES.SECURITY_GROUP_VPC_ID
  tags   = var.CRS_SG_PROPERTIES.SECURITY_GROUP_TAG
}

resource "aws_security_group_rule" "allow_80_traffic" {
  type        = "ingress"
  description = "Allow only clients on our secure tunnel into AWS to call sizing."
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  prefix_list_ids   = var.MANAGED_PREFIX_ID_LIST
  security_group_id = aws_security_group.core-sizing-lambda-sg.id
}

resource "aws_security_group_rule" "egress_443_traffic" {
  type        = "egress"
  description = ""
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #  prefix_list_ids = []
  security_group_id = aws_security_group.core-sizing-lambda-sg.id
}
