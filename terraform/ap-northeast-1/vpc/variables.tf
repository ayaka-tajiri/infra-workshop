variable "vpc_region" {
  type        = string
  description = "The region name to create the VPC. (e.g. us-west-2)"
}

variable "region_azs" {
  type        = list(string)
  description = "A list of availability zones to use for this VPC. (e.g. [a, b, c]) Make sure to check those AZs are available in the region you specified"
}

variable "cidr_prefix" {
  type        = string
  description = "The prefix CIDR. (e.g. use 10.100 if you want 10.100.0.0/16)"
}

variable "private_cidr_postfix" {
  type        = list(string)
  description = "The postfix CIDR for the app private subnets"
  default     = ["0.0", "32.0", "64.0", "96.0"]
}

variable "public_cidr_postfix" {
  type        = list(string)
  description = "The postfix CIDR for the public subnets"
  default     = ["128.0", "144.0", "160.0", "176.0"]
}
