output "lambda_sensitive_value" {
  value     = "${module.lambda_function.sensitive_value}"
  sensitive = true
}
