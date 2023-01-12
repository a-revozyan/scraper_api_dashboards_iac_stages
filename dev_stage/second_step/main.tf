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
    key            = "dev_stage/scraperapidash/secondstep.tfstate"
    region         = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "ecs" {
  source                 = "../../modules/ecs/"
  ecs_app_task_role      = data.terraform_remote_state.first_step.outputs.app_task_role_arn
  ecs_app_execution_role = data.terraform_remote_state.first_step.outputs.ecs_app_execution_role
  sel_repository_arn     = data.terraform_remote_state.first_step.outputs.sel_repository_arn
  sel_repository_name    = data.terraform_remote_state.first_step.outputs.sel_repository_name
  api_repository_arn     = data.terraform_remote_state.first_step.outputs.api_repository_arn
  api_repository_name    = data.terraform_remote_state.first_step.outputs.api_repository_name
  dash_repository_arn    = data.terraform_remote_state.first_step.outputs.dash_repository_arn
  dash_repository_name   = data.terraform_remote_state.first_step.outputs.dash_repository_name
  backend_subnet         = data.terraform_remote_state.first_step.outputs.backend_subnet
  frontend_subnets       = data.terraform_remote_state.first_step.outputs.frontend_subnets
  api01_security_group   = data.terraform_remote_state.first_step.outputs.api01_security_group
  dash01_security_group  = data.terraform_remote_state.first_step.outputs.dash01_security_group
  target_group           = module.nlb.target_group
  target_group2          = module.nlb.target_group2
  env                    = var.stage
}

module "nlb" {
  source                = "../../modules/nlb/"
  vpc_id                = data.terraform_remote_state.first_step.outputs.vpc_id
  frontend_subnet_ids   = data.terraform_remote_state.first_step.outputs.frontend-subnet_ids
  env                   = var.stage
}
