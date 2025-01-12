# Step 8 - Add variables
variable "default_tags" {
  default = {
    "Owner" = "acs730"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Step 8 - Add variables
variable "prefix" {
  default     = "week6"
  type        = string
  description = "Name prefix"
}

# Step 9 - Provision public subnet in default VPC
variable "cidr_block" {
  default     = "172.31.97.0/24"
  type        = string
  description = "Subnet CIDR"
}

