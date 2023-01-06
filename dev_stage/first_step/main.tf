terraform {
  required_version = "1.3.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }

  backend "s3" {
    bucket         = "maintfstatebucketarevozyan"
    dynamodb_table = "main_terraformtfstate"
    key            = "dev_stage/scraperapidash/firststep.tfstate"
    region         = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "s3" {
  source = "../../modules/s3/"
  env    = var.stage
}

module "vpc" {
  source = "../../modules/vpc/"
  env    = var.stage
}

module "iam" {
  depends_on              = [module.s3, module.vpc]
  source                  = "../../modules/iam/"
  cars_data_s3_bucket_arn = module.s3.cars_data_s3_bucket_arn
  env                     = var.stage
}

module "ecr" {
  depends_on = [module.iam]
  source     = "../../modules/ecr/"
  env        = var.stage
}

module "sgs" {
  source = "../../modules/sgs/"
  vpc_id = module.vpc.vpc_id
  env    = var.stage
}