resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.bucket_name}-${var.env}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "${var.bucket_name}"
    Env = "${var.env}"
  }
}
