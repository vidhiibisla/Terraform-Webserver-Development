

#----------------------------------------------------------
# ACS730 - Lab 3 - Terraform Introduction
#
# Build EC2 Instances
#
#----------------------------------------------------------

#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "public_subnet" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-week4-dhana"            // Bucket from where to GET Terraform State
    key    = "01-networking/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                       // Region where bucket created
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Reference subnet provisioned by 01-Networking 
resource "aws_instance" "my_amazon" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.public_subnet.outputs.subnet_id
  associate_public_ip_address = true
  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }
  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-Amazon-Linux"
    }
  )
}

# Attach EBS volume
resource "aws_volume_attachment" "ebs_att" {
  count       = var.env == "prod" ? 1 : 0
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_ebs[count.index].id
  instance_id = aws_instance.my_amazon.id
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = var.prefix
  public_key = file("${var.prefix}.pub")
}

# Create another EBS volume
resource "aws_ebs_volume" "web_ebs" {
  count             = var.env == "prod" ? 1 : 0
  availability_zone = data.aws_availability_zones.available.names[1]
  size              = 40

  tags = merge(local.default_tags,
    {
      "Name" = "${var.prefix}-EBS"
    }
  )
}