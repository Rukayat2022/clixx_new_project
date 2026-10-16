# Input Variables
# AWS Region

variable "AWS_REGION" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}


# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}




variable "instance_type" {
  default = "t2.micro"
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
