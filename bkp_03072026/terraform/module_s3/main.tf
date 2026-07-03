provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket-terraform-state-file" {
    bucket = "bucket-s3-terraform-demo"

}