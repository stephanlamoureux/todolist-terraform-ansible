// Create S3 bucket
resource "aws_s3_bucket" "todolist_static_site" {
  bucket = "stephan-todolist-flask"

  tags = {
    instance_role = "frontend"
  }
}

// Upload index.html to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.todolist_static_site.bucket
  key          = "index.html"
  source       = "./assets/index.html"
  content_type = "text/html"
  acl          = "public-read"
}

// Sets the ownership control of the S3 bucket, determining how object ownership works in terms of ACLs and bucket policies.
resource "aws_s3_bucket_ownership_controls" "todolist_static_site_controls" {
  bucket = aws_s3_bucket.todolist_static_site.bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

// Configures the public access settings for the bucket. Setting these to false allows public access as per the bucket's ACL and policy.
resource "aws_s3_bucket_public_access_block" "todolist_static_site_access_block" {
  bucket = aws_s3_bucket.todolist_static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// Explicitly sets the ACL of the bucket to public-read, allowing public read access to the bucket.
resource "aws_s3_bucket_acl" "todolist_static_site_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.todolist_static_site_controls,
    aws_s3_bucket_public_access_block.todolist_static_site_access_block,
  ]

  bucket = aws_s3_bucket.todolist_static_site.id
  acl    = "public-read"
}

// Sets up the bucket for website hosting with index.html as the index document.
resource "aws_s3_bucket_website_configuration" "my_static_site_config" {
  bucket = aws_s3_bucket.todolist_static_site.bucket

  index_document {
    suffix = "index.html"
  }
}

// This bucket policy allows public read access to the website's files.
resource "aws_s3_bucket_policy" "my_static_site_policy" {
  bucket = aws_s3_bucket.todolist_static_site.bucket

  policy = jsonencode({
    Statement = [
      {
        Action    = ["s3:GetObject"],
        Effect    = "Allow",
        Resource  = ["${aws_s3_bucket.todolist_static_site.arn}/*"],
        Principal = "*"
      }
    ]
  })
}

