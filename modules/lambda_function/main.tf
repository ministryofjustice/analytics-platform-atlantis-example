data "aws_iam_policy_document" "hello_world" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "hello_world" {
  name               = "tf_enterprise_hello_world_lambda_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.hello_world.json}"
}

resource "aws_lambda_function" "hello_world" {
  filename         = "${path.module}/hello_world.zip"
  source_code_hash = "${data.archive_file.hello_world.output_base64sha256}"
  function_name    = "tf_enterprise_hello_world_${var.env}"
  role             = "${aws_iam_role.hello_world.arn}"
  handler          = "hello_handler"
  runtime          = "python3.6"
  timeout          = 300
  depends_on       = ["data.archive_file.hello_world"]

  environment {
    variables = {
      SENSITIVE = "${var.sensitive_value}"
    }
  }
}
