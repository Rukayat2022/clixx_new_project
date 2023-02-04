# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}


variable "AWS_REGION" {}
# variable "AWS_ACCESS_KEY" {}
# variable "AWS_SECRET_KEY" {}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

variable "dev_account_num" {}

variable "ami" {
  default = "ami-08f3d892de259504d"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "clixx-bucket" {
  default = "stackclixximagesrukayat"
}



variable "db_instance_type" {
  default = "db.t2.micro"
  type    = string
}


variable "clixxsnapshot" {
  default = "arn:aws:rds:us-east-1:577701061234:snapshot:wordpressdbclixxsnap"
}

variable "database-instance-identifier" {
  default = "wordpressdbclixxretailapp"
  type    = string
}

variable "db_snapshot_identifier" {}


variable "dev_names" {

  default = ["sdf", "sdh", "sdg", "sdi", "sdj"]
}


variable "dev_nam" {
  default = ["/dev/sdf", "/dev/sdg", "/dev/sdh", "/dev/sdi", "/dev/sdj"]
}


variable "volume_size" {
  default = 10
}

variable "counter" {
  default = 5
}


variable "mount_point" {
  default = "/var/www/html"
}

variable "PATH_TO_BASTION_PUBLIC_KEY" {
  default = "test_instance_kp.pub"
}

variable "PATH_TO_APPSERVER_PUBLIC_KEY" {
  default = "private_ruk.pub"
}

#variable "new_rds" {}

variable "pass_wort" {}

variable "dbuser_name" {}

variable "dbasename" {}

/*
variable "priv_subnets" {
  default = ["aws_subnet.app_server_private_az1.id", "aws_subnet.app_server_private_az2.id"]
}
*/