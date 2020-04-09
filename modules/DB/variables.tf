variable "db_name" {
    type = string
    default = "rdhrDB"
}


variable "db_billing" {
    type = string
    description = "Billing type for the Dynamo DB"
    default = "PROVISIONED"
}

variable "db_read_cap" {
  type = string
  description = "Reading capability of the database"
  default = "5"
}

variable "db_write_cap" {
  type = string
  description = "Writting capability of the database"
  default = "5"
}
