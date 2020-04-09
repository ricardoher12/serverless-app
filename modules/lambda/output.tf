output "post_function_name" {
  value = "${aws_lambda_function.post.function_name}"
}

output "post_function_arn" {
  value = "${aws_lambda_function.post.arn}"
}

output "get_function_name" {
  value = "${aws_lambda_function.get.function_name}"
}

output "get_function_arn" {
  value = "${aws_lambda_function.get.arn}"
}

output "delete_function_name" {
  value = "${aws_lambda_function.delete.function_name}"
}

output "delete_function_arn" {
  value = "${aws_lambda_function.delete.arn}"
}