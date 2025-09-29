variable "region" {
  type        = string
  description = "The AWS region to deploy resources"
}

variable "assume_role_arn" {
  type        = string
  description = "The ARN of the role to assume by Terraform"
}

variable "assume_role_session_name" {
  description = "The session name to use when assuming the role."
  type        = string
}