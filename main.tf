
variable "profile" {
  type = string
  default = "default"
}

variable "region" {
  type = string
  default = "us-west-2"
}


provider "aws" {
    profile = var.profile
    region = var.region
    shared_credentials_file = "C:/Users/Ricardoher/.aws/credentials"
}

terraform {
  backend "s3" {
    bucket = "rdhr-bucket"
    key    = "terraform/key"
    region = "us-west-2"
  }
}

module "ApiGateway" {
  source = "./modules/API_Gateway"
  aws_profile   = var.profile
  aws_region    = var.region
  function_post_name    = "${module.lambda.post_function_name}"
  function_post_arn     = "${module.lambda.post_function_arn}"
  function_get_name     = "${module.lambda.get_function_name}"
  function_get_arn      = "${module.lambda.get_function_arn}"
  function_delete_name  = "${module.lambda.delete_function_name}"
  function_delete_arn   = "${module.lambda.delete_function_arn}"
  domain_name           = "rdhrAPI.com" 
}


module "lambda" {
  source      = "./modules/lambda"
  stack_name  = "rdhr"
  table_arn   = "${module.dynamodb.db_arn}"
  table_name  = "${module.dynamodb.table_name}"
}

module "dynamodb" {
  source      = "./modules/DB"
}
