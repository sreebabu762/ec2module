resource "aws_iam_role" "sree_iam_role" {
  name = "sree_iam_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "sree_iam_role"
  }
}

resource "aws_iam_policy" "s3readonlypolicy" {
  name        = "s3-readonly-policy"
  description = "s3-readonly-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*progressive-claims*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "dynamoreadonlypolicy" {
  name        = "dynamodb-readonly-policy"
  description = "dynamodb readonly policy"

  policy = <<EOF
{   
      "Version": "2012-10-17",
      "Statement": [
        {
            "Action": [
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DescribeScalingActivities",
                "application-autoscaling:DescribeScalingPolicies",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "datapipeline:DescribeObjects",
                "datapipeline:DescribePipelines",
                "datapipeline:GetPipelineDefinition",
                "datapipeline:ListPipelines",
                "datapipeline:QueryObjects",
                "dynamodb:BatchGetItem",
                "dynamodb:Describe*",
                "dynamodb:List*",
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:PartiQLSelect",
                "dax:Describe*",
                "dax:List*",
                "dax:GetItem",
                "dax:BatchGetItem",
                "dax:Query",
                "dax:Scan",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "iam:GetRole",
                "iam:ListRoles",
                "kms:DescribeKey",
                "kms:ListAliases",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "lambda:ListFunctions",
                "lambda:ListEventSourceMappings",
                "lambda:GetFunctionConfiguration",
                "resource-groups:ListGroups",
                "resource-groups:ListGroupResources",
                "resource-groups:GetGroup",
                "resource-groups:GetGroupQuery",
                "tag:GetResources",
                "kinesis:ListStreams",
                "kinesis:DescribeStream",
                "kinesis:DescribeStreamSummary"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "cloudwatch:GetInsightRuleReport",
            "Effect": "Allow",
            "Resource": "arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "s3policy-attach" {
  role       = "${aws_iam_role.sree_iam_role.name}"
  policy_arn = aws_iam_policy.s3readonlypolicy.arn
}

resource "aws_iam_role_policy_attachment" "dynamopolicy-attach" {
  role       = aws_iam_role.sree_iam_role.name
  policy_arn = aws_iam_policy.dynamoreadonlypolicy.arn
}