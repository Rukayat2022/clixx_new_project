
terraform {
  backend "s3" {
    bucket = "new-clixx-dev-tf-state"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "clixx-state-locking_new"
    encrypt = true
role_arn       = "arn:aws:iam::315407446881:role/Engineer"
  }
}

