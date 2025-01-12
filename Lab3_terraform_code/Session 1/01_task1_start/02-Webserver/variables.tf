# Instance type
variable "instance_type" {
  default     = "t3.micro"
  description = "Type of the instance"
  type        = string
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "acs730"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "week4"
  type        = string
  description = "Name prefix"
}


