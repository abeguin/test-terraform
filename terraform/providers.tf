terraform {
  required_version = "~>1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.13.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~>2.7.1"
    }
  }


}

provider "aws" {

  assume_role {
    role_arn = var.aws_assume_role
  }

  default_tags {
    tags = {

    }
  }
}