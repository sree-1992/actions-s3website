# Creating S3 Bucket For Website Hosting

resource "aws_s3_bucket" "website_bucket" {

  bucket = "${var.hostname}.${var.domain_name}"

  tags = {

    Name = "${var.hostname}.${var.domain_name}"
  }
}


# Enabling Bucket Website Hosting

resource "aws_s3_bucket_website_configuration" "website_bucket" {

  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}


# Define the template_file data source to read the IAM policy document

data "template_file" "s3_public_policy" {

  template = file("${path.module}/s3_public_policy.json")

  # Pass variables to the IAM policy document template
  vars = {
    bucket_name = "${var.hostname}.${var.domain_name}"
  }
}

# Disable Block all public access

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Applying Public Bucket Policy To website bucket

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.template_file.s3_public_policy.rendered
  depends_on = [ resource.aws_s3_bucket_public_access_block.public_access ]
}


resource "aws_s3_object" "website_file" {

  for_each     = fileset("${path.module}/${var.local_website_path}", "**/*")
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = each.key
  source       = "${path.module}/${var.local_website_path}/${each.key}"
  content_type = lookup(var.content_type_mapping, regex("\\.[^.]+$", each.key), null)
  etag         = filemd5("${var.local_website_path}/${each.value}")

}

resource "aws_route53_record" "website_bucket_record" {

  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "${var.hostname}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website_bucket.website_domain
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}

