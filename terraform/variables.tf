variable "ec2_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Valheim server EC2 instance type"
}

variable "ec2_ami_id" {
  type        = string
  description = "Valheim server EC2 AMI ID"
}

variable "aws_region" {
  type        = string
  description = "AWS Region for all the resources"
}

variable "sns_email" {
  type        = string
  description = "SNS Email address where notifications about server events are sent"
}

variable "ec2_management_source_ip" {
  type        = string
  description = "Source IP Address to be added to the security group for allowing ssh connection. Preferrably defined using TF_VAR environment variable"
}

variable "project_common_tag" {
  type        = string
  description = "Common tag for all valheim resources"
}