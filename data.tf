# Call current profile account information
data "aws_caller_identity" "current" {}


data "aws_secretsmanager_secret_version" "wp_creds" {
  # Fill in the name you gave to your secret
  secret_id = "clixxcreds"
}

