#core sizing lambda iam role
resource "aws_iam_role" "core-sizing-lambda-role" {
  name = var.CRS_LAMBDA_IAM_ROLE_POLICY_NAMES.CRS_LAMBDA_IAM_ROLE_NAME
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

#To access msk cluster from lambda function core sizing lambda permission policy
resource "aws_iam_role_policy" "core-sizing-lambda-permission-policy" {
  name = var.CRS_LAMBDA_IAM_ROLE_POLICY_NAMES.CRS_MSK_LAMBDA_PERMISSION_POLICY_NAME
  role = aws_iam_role.core-sizing-lambda-role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeInstances",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:AttachNetworkInterface"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "timestream:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : "lambda:InvokeFunctionUrl",
          "Resource" : "arn:aws:lambda:*:*:*:*",
          "Effect" : "Allow"
        }
      ]
    }
  )
}

#CRS MSK core memory persister lambda role
resource "aws_iam_role" "msk-core-memory-persister-lambda-role" {
  name = var.CRS_LAMBDA_IAM_ROLE_POLICY_NAMES.CRS_MSK_MEM_PERSISTER_LAMBDA_IAM_ROLE_NAME
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

#CRS MSK core memory persister lambda add permission to the role
resource "aws_iam_role_policy" "msk-core-memory-persister-lambda-permission-policy" {
  name = var.CRS_LAMBDA_IAM_ROLE_POLICY_NAMES.CRS_MSK_MEM_PERSISTER_LAMBDA_PERMISSION_POLICY_NAME
  role = aws_iam_role.msk-core-memory-persister-lambda-role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "ec2:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "timestream:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "glue:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "kafka-cluster:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "kafka:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
}

#IAM policy for logging from a lambda
resource "aws_iam_policy" "lambda_logging" {
  name        = var.CRS_LAMBDA_IAM_ROLE_POLICY_NAMES.CRS_LAMBDA_LOGGING_IAM_POLICY_NAME
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        }
      ]
    }
  )
}

#Attach core sizing lambda logs to lambda role
resource "aws_iam_role_policy_attachment" "core-sizing-lambda-logs" {
  role       = aws_iam_role.core-sizing-lambda-role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

#Attach core sizing persister lambda logs to persister lambda role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.msk-core-memory-persister-lambda-role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
