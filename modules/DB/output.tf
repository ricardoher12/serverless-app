output "db_arn" {
  value = "${aws_dynamodb_table.dynamodb_table.arn}"
}

output "table_name" {
  value = "${aws_dynamodb_table.dynamodb_table.name}"
}

