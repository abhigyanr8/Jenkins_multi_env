#Core Sizing Load Balancer
resource "aws_lb" "core-sizing-lb" {
  name                       = var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LB_NAME
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LB_SECURITY_GP_IDS]
  subnets                    = var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LB_SUBNETS
  enable_deletion_protection = true
}

#Core Sizing Load Balancer Listener
resource "aws_lb_listener" "core-sizing-lb-listener" {
  load_balancer_arn = aws_lb.core-sizing-lb.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.core-sizing-target-group.arn
  }
}

#Core Sizing Load Balancer target Group
resource "aws_lb_target_group" "core-sizing-target-group" {
  name        = var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LB_TARGET_GP_NAME
  target_type = "lambda"
}

#Core Sizing Lambda Permission
resource "aws_lambda_permission" "core-sizing-lambda-perm" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LAMBDA_FUN_NAME
  qualifier     = var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LAMBDA_ALIAS_NAME
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.core-sizing-target-group.arn
}

#Core Sizing Load Balancer Target Group Attachment
resource "aws_lb_target_group_attachment" "core-sizing-target-group-attachment" {
  target_group_arn = aws_lb_target_group.core-sizing-target-group.arn
  target_id        = var.CORE_SIZING_LOAD_BALANCER_PROPERTIES.CORE_SIZING_LAMBDA_ALIAS_ID
  depends_on       = [aws_lambda_permission.core-sizing-lambda-perm]
}

#Core Sizing Load Balancer Listener Rule
resource "aws_lb_listener_rule" "core-sizing-lb-listener-rule" {
  listener_arn = aws_lb_listener.core-sizing-lb-listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.core-sizing-target-group.arn
  }
  condition {
    http_request_method {
      values = var.CORE_SIZING_LB_REQUEST_METHODS
    }
  }
}

#MSK Cluster Load Balancer
resource "aws_lb" "msk-lb" {
  name                       = var.CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES.CORE_SIZING_MSK_LB_NAME
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = var.CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES.CORE_SIZING_MSK_LB_SUBNETS
  enable_deletion_protection = true
}

#MSK Cluster Load Balancer Listener
resource "aws_lb_listener" "msk-lb-listener" {
  load_balancer_arn = aws_lb.msk-lb.arn
  port              = 9092
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.msk-target-group.arn
  }
}

#MSK Cluster Load Balancer Target Group
resource "aws_lb_target_group" "msk-target-group" {
  depends_on  = [aws_lb.msk-lb]
  name        = var.CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES.CORE_SIZING_MSK_LB_TARGET_GP_NAME
  port        = 9092
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES.CORE_SIZING_MSK_LB_VPC_ID
}

#MSK Cluster Load Balancer Target Group Attachment
resource "aws_lb_target_group_attachment" "msk-target-group-attachment" {
  # msk-network-interface is of type list(object) - converting it to a map of format:
  #   { (string)arn, (object)element of list with that arn }
  # is necessary to iterate over due to Terraform limitations with for loops
  for_each = {
    for ni in var.CORE_SIZING_MSK_LOAD_BALANCER_PROPERTIES.CORE_SIZING_MSK_NI_LIST :
    ni.arn => ni
  }
  target_group_arn = aws_lb_target_group.msk-target-group.arn
  target_id        = each.value.private_ip
  port             = 9092
}
