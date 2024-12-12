# Hosting a static website using Terraform
**Project Goal**

Implement AWS S3 usecase of hosting a static website as described in https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html using terraform


**Components**
1. AWS S3 Bucket
2. Terraform
3. Any HTML file to be used as index file

**Workflow**

Following workflow of https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html

1. Website endpoints
Create an s3 bucket
```
resource "aws_s3_bucket" "project1bucket" {
  bucket = "my-tf-one-bucket"

  tags = {
    Name        = "My bucket Project 1"
  }
} 
```

2. Enabling website hosting

```
resource "aws_s3_bucket_website_configuration" "project1bucket" {
  bucket = aws_s3_bucket.project1bucket.id

  index_document {
    suffix = "webindex.html"
  }

  error_document {
    key = "error.html"
  }

}
```
3. Configuring an index document
```
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.project1bucket.id
  key    = "webindex.html"
  source = "webindex.html"
  content_type = "text/html"
}
```
4. Configuring a custom error document
```
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.project1bucket.id
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}
```
5. Setting permissions for website access
Step 1: Edit S3 Block Public Access settings
```
resource "aws_s3_bucket_public_access_block" "project1bucket" {
  bucket = aws_s3_bucket.project1bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```
Step 2: Add a bucket policy
```
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
```
