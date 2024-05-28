variable "region" {
  description = "The AWS region where resources will be provisioned"
  type        = string
}

variable "access_key" {
  description = "The AWS access key used to authenticate Terraform with AWS"
  type        = string
}

variable "secret_key" {
  description = "The AWS secret key used to authenticate Terraform with AWS"
  type        = string
}

variable "domain_name" {
  description = "The public domain name"
  type        = string
}

variable "hostname" {

  description = "The hostname for the s3 bucket"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "project_env" {
  description = "The environment of the project (e.g., dev, staging, prod)"
  type        = string
}

variable "local_website_path" {

  description = "name of the directory where we keeps website files"
  type        = string

}

