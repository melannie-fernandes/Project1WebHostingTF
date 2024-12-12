resource "aws_s3_bucket" "project1bucket" {
  bucket = "my-tf-one-bucket"

  tags = {
    Name        = "My bucket Project 1"
  }
}
resource "aws_s3_bucket_public_access_block" "project1bucket" {
  bucket = aws_s3_bucket.project1bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.project1bucket.id
  key    = "webindex.html"
  source = "webindex.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.project1bucket.id
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "project1bucket" {
  bucket = aws_s3_bucket.project1bucket.id

  index_document {
    suffix = "webindex.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.project1bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
	  "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": [
        "${aws_s3_bucket.project1bucket.arn}",
        "${aws_s3_bucket.project1bucket.arn}/*"
      ]
    }
  ]
}
EOF
}