resource "aws_s3_bucket" "clixx-bucket" {
  bucket = "stackclixximagesrukayat"

tags = {
    Name       = "stackclixximagesrukayat"
    OwnerEmail = "omoyeni982@gmail.com"
    Stackteam  = "stackcloud9"
    Schedule   = "A"
    Backup     = "Yes"
  }
}

resource "aws_s3_bucket_acl" "clixx-bucket" {
  bucket = aws_s3_bucket.clixx-bucket.id
  acl    = "private"
}