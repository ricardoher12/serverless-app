#data "aws_region" "current" {}
#data "aws_caller_identity" "current" {}

data "archive_file" "lambda_post" {
  type        = "zip"
  source_dir  = "${path.module}/code/post"
  output_path = "${path.module}/post.zip"
}

data "archive_file" "lambda_get" {
  type        = "zip"
  source_dir  = "${path.module}/code/get"
  output_path = "${path.module}/get.zip"
}

data "archive_file" "lambda_delete" {
  type        = "zip"
  source_dir  = "${path.module}/code/delete"
  output_path = "${path.module}/delete.zip"
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_${var.stack_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "lambda-policy-sms-${var.stack_name}"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "logs:*"
         ],
         "Resource": [
            "*"
         ]
      },
      {
         "Effect": "Allow",
         "Action": [
            "dynamodb:*"
         ],
         "Resource": [
            "${var.table_arn}"
         ]
      }
  ]
}
EOF
}

resource "aws_lambda_function" "post" {
  filename         = data.archive_file.lambda_post.output_path
  function_name    = "${var.stack_name}-post"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256(data.archive_file.lambda_post.output_path)
  publish          = true
  timeout          = 5

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}

resource "aws_lambda_function" "get" {
  filename         = data.archive_file.lambda_get.output_path
  function_name    = "${var.stack_name}-get"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256(data.archive_file.lambda_get.output_path)
  publish          = true
  timeout          = 5

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}


resource "aws_lambda_function" "delete" {
  filename         = data.archive_file.lambda_delete.output_path
  function_name    = "${var.stack_name}-delete"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256(data.archive_file.lambda_delete.output_path)
  publish          = true
  timeout          = 5

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}