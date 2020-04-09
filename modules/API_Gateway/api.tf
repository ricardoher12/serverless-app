data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  stage_name = "v1"
}

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "Api Gateway for http requests"
}

#Lambda permission Post
resource "aws_lambda_permission" "apigw_lambda_post" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_post_arn
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/*"
}

#Lambda permission Get
resource "aws_lambda_permission" "apigw_lambda_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_get_arn
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/*"
}

#Lambda permission Delete
resource "aws_lambda_permission" "apigw_lambda_delete" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_delete_arn
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/*"
}

#Method Post
resource "aws_api_gateway_method" "post" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_rest_api.api.root_resource_id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = false
}

#Method Get
resource "aws_api_gateway_method" "get" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_rest_api.api.root_resource_id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
  request_parameters = {
    "method.request.path.id" = true
  }
}

#Method Delete
resource "aws_api_gateway_method" "delete" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_rest_api.api.root_resource_id
  http_method      = "DELETE"
  authorization    = "NONE"
  api_key_required = false
  request_parameters = {
    "method.request.path.id" = true
  }
}


#Api integration Post 
resource "aws_api_gateway_integration" "post_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.post.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.function_post_name}/invocations"
  integration_http_method = "POST"
}

#Api integration Get 
resource "aws_api_gateway_integration" "get_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.get.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.function_get_name}/invocations"
  integration_http_method = "POST"
  request_parameters = {
      "integration.request.path.id" = "method.request.path.id"
  }
}

#Api integration Delete 
resource "aws_api_gateway_integration" "delete_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.delete.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.function_delete_name}/invocations"
  integration_http_method = "POST"
  request_parameters = {
      "integration.request.path.id" = "method.request.path.id"
  }
}

#Method response Post
resource "aws_api_gateway_method_response" "post_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"
 /*response_models = {
         "application/json" = "Empty"
    }*/
}

#Method response Get
resource "aws_api_gateway_method_response" "get_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
  /*response_models = {
         "application/json" = "Empty"
    }*/
}

#Method response Delete
resource "aws_api_gateway_method_response" "delete_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.delete.http_method
  status_code = "200"
  /*response_models = {
         "application/json" = "Empty"
    }*/
}

#Integration Response Post
resource "aws_api_gateway_integration_response" "post_response" {
  depends_on = [aws_api_gateway_integration.post_method_integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.post_200.status_code
}

#Integration Response Get
resource "aws_api_gateway_integration_response" "get_response" {
  depends_on = [aws_api_gateway_integration.get_method_integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.get_200.status_code
}

#Integration Response Delete
resource "aws_api_gateway_integration_response" "delete_response" {
  depends_on = [aws_api_gateway_integration.delete_method_integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.delete.http_method
  status_code = aws_api_gateway_method_response.delete_200.status_code
}

#Method settings post
resource "aws_api_gateway_method_settings" "post_settings" {
  depends_on = [aws_api_gateway_integration.post_method_integration, aws_api_gateway_account.settings, aws_api_gateway_deployment.deployment]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "/*/${aws_api_gateway_method.post.http_method}"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
//    caching_enabled = false
  }

}


#Method settings get
resource "aws_api_gateway_method_settings" "get_settings" {
  depends_on = [aws_api_gateway_integration.get_method_integration, aws_api_gateway_account.settings, aws_api_gateway_deployment.deployment]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "/*/${aws_api_gateway_method.get.http_method}"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
//    caching_enabled = false
  }
}

#Method settings Delete
resource "aws_api_gateway_method_settings" "delete_settings" {
  depends_on = [aws_api_gateway_integration.delete_method_integration, aws_api_gateway_account.settings, aws_api_gateway_deployment.deployment]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "/*/${aws_api_gateway_method.delete.http_method}"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
//    caching_enabled = false
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.delete_method_integration, aws_api_gateway_integration.post_method_integration, aws_api_gateway_integration.get_method_integration, aws_api_gateway_account.settings]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  depends_on = [aws_api_gateway_deployment.deployment]
  stage_name    = local.stage_name
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id

  #provisioner "local-exec" {
    #command = "aws --region ${var.aws_region} --profile ${var.aws_profile} apigateway update-stage --rest-api-id ${aws_api_gateway_rest_api.api.id} --stage-name '${local.stage_name}' --patch-operations op=replace,path=/*/*/logging/dataTrace,value=true op=replace,path=/*/*/logging/loglevel,value=INFO op=replace,path=/*/*/metrics/enabled,value=true"
  #}
}



resource "aws_api_gateway_account" "settings" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_role_rdhr"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
