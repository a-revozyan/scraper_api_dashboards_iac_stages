terraform {
  required_version = "1.3.6"

  backend "s3" {
    bucket         = "maintfstatebucketarevozyan"
    dynamodb_table = "main_terraformtfstate"
    key            = "dev_stage/scraperapidash/terraform.tfstate"
    region         = "us-east-2"
  }
}

module "s3" {
  source = "git@github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/s3?ref=v0.0.1"
  env    = var.stage
}

module "vpc" {
  source = "git@github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/vpc?ref=v0.0.1"
  env    = var.stage
}

module "iam" {
  depends_on              = [module.s3, module.vpc]
  source = "git::https://github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/nlb?ref=v0.0.1"
  cars_data_s3_bucket_arn = module.s3.cars_data_s3_bucket_arn
  env                     = var.stage
}

module "ecr" {
  depends_on = [module.iam]
  source = "git::https://github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/nlb?ref=v0.0.1"
  env    = var.stage
}

module "sgs" {
  source = "git::https://github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/nlb?ref=v0.0.1"
#  source = "../../modules/sgs"
  vpc_id = module.vpc.vpc_id
  env    = var.stage
}

module "ecs" {
  depends_on              = [module.iam, module.ecr]
  source                  = "git::https://github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/nlb?ref=v0.0.1"
  ecs_app_task_role       = module.iam.app_task_role_arn
  ecs_app_execution_role  = module.iam.app_execution_role_arn
  sel_repository_arn      = module.ecr.aws_ecr_repository_arn_selenium
  sel_repository_name     = module.ecr.aws_ecr_repository_name_selenium
  api_repository_arn      = module.ecr.aws_ecr_repository_arn_api
  api_repository_name     = module.ecr.aws_ecr_repository_name_api
  dash_repository_arn     = module.ecr.aws_ecr_repository_arn_dash
  dash_repository_name    = module.ecr.aws_ecr_repository_name_dash
  backend_subnet          = module.vpc.backend-subnet_ids
  frontend_subnets        = module.vpc.frontend-subnet_ids
  api01_security_group    = module.sgs.api_sg_5050
  dash01_security_group   = module.sgs.dash_sg_5000
  target_group            = module.nlb.target_group
  target_group2           = module.nlb.target_group2
  env                     = var.stage
}

module "nlb" {
  depends_on            = [module.vpc]
  source                = "git::https://github.com:arevozyan/scraper_api_dashboards_iac_modules//tf_modules/nlb?ref=v0.0.1"
  vpc_id                = module.vpc.vpc_id
  frontend_subnet_ids   = module.vpc.frontend-subnet_ids
  env                   = var.stage
}