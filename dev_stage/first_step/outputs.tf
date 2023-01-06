output "app_task_role_arn" {
  description = "app_task_role_arn"
  value = module.iam.app_task_role_arn
}

output "ecs_app_execution_role" {
  description = "ecs_app_execution_role"
  value = module.iam.app_execution_role_arn
}

output "sel_repository_arn" {
  description = "sel_repository_arn"
  value = module.ecr.aws_ecr_repository_arn_selenium
}

output "sel_repository_name" {
  description = "sel_repository_name"
  value = module.ecr.aws_ecr_repository_name_selenium
}

output "api_repository_arn" {
  description = "api_repository_arn"
  value = module.ecr.aws_ecr_repository_arn_api
}

output "api_repository_name" {
  description = "api_repository_name"
  value = module.ecr.aws_ecr_repository_name_api
}

output "dash_repository_arn" {
  description = "dash_repository_arn"
  value = module.ecr.aws_ecr_repository_arn_dash
}

output "dash_repository_name" {
  description = "dash_repository_name"
  value = module.ecr.aws_ecr_repository_name_dash
}

output "backend_subnet" {
  description = "backend_subnet"
  value = module.vpc.backend-subnet_ids
}

output "frontend_subnets" {
  description = "frontend_subnets"
  value = module.vpc.frontend-subnet_ids
}

output "dash01_security_group" {
  description = "dash01_security_group"
  value = module.sgs.dash_sg_5000
}

output "api01_security_group" {
  description = "api01_security_group"
  value = module.sgs.api_sg_5050
}

output "backend-subnet_ids" {
  description = "backend-subnet_ids"
  value = module.vpc.backend-subnet_ids
}

output "frontend-subnet_ids" {
  description = "backend-subnet_ids"
  value = module.vpc.frontend-subnet_ids
}

output "vpc_id" {
  description = "backend-subnet_ids"
  value = module.vpc.vpc_id
}