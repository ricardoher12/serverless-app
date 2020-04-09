resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.db_name
  billing_mode   = var.db_billing
  read_capacity  = var.db_read_cap
  write_capacity = var.db_write_cap
  hash_key       = "TeamId"
#  range_key      = "TeamId"

  attribute {
    name = "TeamId"
    type = "N"
  }

  attribute {
    name = "TeamName"
    type = "S"
  }

  attribute {
    name = "Points"
    type = "N"
  }

 

 # ttl {
  #  attribute_name = "TimeToExist"
   # enabled        = false
  #}

  global_secondary_index {
    name               = "TeamNameIndex"
    hash_key           = "TeamName"
    range_key          = "Points"
    write_capacity     = var.db_write_cap
    read_capacity      = var.db_read_cap
    projection_type    = "INCLUDE"
    non_key_attributes = ["TeamId"]
  }

  tags = {
    Name        = var.db_name
    Environment = "production"
  }
}