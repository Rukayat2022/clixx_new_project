# provider "aws" {
#   #region     = "${local.wp_creds.AWS_REGION}"
#   # access_key = "${local.wp_creds.AWS_ACCESS_KEY}"
#   # secret_key = "${local.wp_creds.AWS_SECRET_KEY}"

#   AWS_ACCESS_KEY = "AKIAS2HXXNLM6B6SXQOX"
#   AWS_SECRET_KEY = "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"
#   AWS_REGION     = "us-east-1"
  

#   assume_role {
#     #The role ARN within Account B to AssumeRole into. Created in step 1.
#     role_arn = "arn:aws:iam::315407446881:role/Engineer"

#   }
# }


provider "aws" {
  # region     = var.AWS_REGION
  # access_key = var.AWS_ACCESS_KEY
  # secret_key = var.AWS_SECRET_KEY
  #profile = var.aws_profile
  default = var.aws_profile

  assume_role {
    #The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::315407446881:role/Engineer"

  }
}


