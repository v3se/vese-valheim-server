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

variable "container_name" {
  type        = string
  description = "ECS container name"
}

variable "ecs_image" {
  type        = string
  description = "ECS Image name that will be pulled"
}

variable "public_key" {
  type        = string
  description = "Public key that can be used to access the ec2 instances"
}

variable "adminlist_ids" {
  type        = list(any)
  description = "List of Valheim Admin Steam IDs"
}

variable "server_name" {
  type        = string
  description = "Valheim server name that is visible in the server browser"
}

variable "world_name" {
  type        = string
  description = "Valheim world name"
}

variable "server_pass" {
  type        = string
  description = "Valheim server password"
}