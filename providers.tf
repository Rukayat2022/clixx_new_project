provider "aws" {
  #profile = var.aws_profile
  region = var.AWS_REGION
  

  assume_role {
    #The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::315407446881:role/Engineer"

  }
}


