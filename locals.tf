locals {
  current_account_info = data.aws_caller_identity.current.account_id
  name_acc_prefix      = local.current_account_info == var.dev_account_num ? "dev" : "unknown"
  region               = "us-east-1"

  vpc_tags = {
    Name       = "main-vpc-${local.name_acc_prefix}"
    OwnerEmail = "omoyeni982@gmail.com"
    Stackteam  = "stackcloud9"
    Schedule   = "A"
    Backup     = "Yes"
  }
}


#locals.tf
locals {
  current = data.aws_caller_identity.current.account_id
  wp_creds = jsondecode(
    data.aws_secretsmanager_secret_version.wp_creds.secret_string
  )
}