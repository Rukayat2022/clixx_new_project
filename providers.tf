provider "aws" {
  region     = "${local.wp_creds.AWS_REGION}"
  # access_key = "${local.wp_creds.AWS_ACCESS_KEY}"
  # secret_key = "${local.wp_creds.AWS_SECRET_KEY}"
  

  assume_role {
    #The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::315407446881:role/Engineer"

  }
}


