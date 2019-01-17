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
  filename         = "${path.module}/hello.py.zip"
  source_code_hash = "${base64sha256(file("${path.module}/hello.py.zip"))}"
  function_name    = "tf_enterprise_hello_world_${var.env}"
  role             = "${aws_iam_role.hello_world.arn}"
  handler          = "hello_handler"
  runtime          = "python3.6"
  timeout          = 300

  environment {
    variables = {
      SENSITIVE = "${var.sensitive_value}"
    }
  }
}
