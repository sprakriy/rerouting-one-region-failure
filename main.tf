# main.tf

module "ecr" {
  source = "./modules/ecr"
}

# --- REGION A STACK (Inherits default us-east-1 provider automatically) ---
module "networking_a" {
  source      = "./modules/networking"
  environment = "prod-us-east-1"
}

module "ecs_a" {
  source           = "./modules/ecs"
  environment      = "prod-us-east-1"
  repository_url   = module.ecr.repository_url
  subnet_ids       = module.networking_a.public_subnet_ids
  ecs_tasks_sg_id  = module.networking_a.ecs_tasks_sg_id
  target_group_arn = module.networking_a.target_group_arn
}

# --- REGION B STACK (Explicitly reaches out to provider.tf's alias) ---
module "networking_b" {
  source      = "./modules/networking"
  providers   = { aws = aws.region_b } # <--- Links to provider.tf alias
  environment = "prod-us-west-2"
}

module "ecs_b" {
  source           = "./modules/ecs"
  providers        = { aws = aws.region_b } # <--- Links to provider.tf alias
  environment      = "prod-us-west-2"
  repository_url   = module.ecr.repository_url
  subnet_ids       = module.networking_b.public_subnet_ids
  ecs_tasks_sg_id  = module.networking_b.ecs_tasks_sg_id
  target_group_arn = module.networking_b.target_group_arn
}

# module "networking" {
#   source      = "./modules/networking"
#   environment = "prod"
# }

# module "ecs" {
#   source           = "./modules/ecs"
#   environment      = "prod"
#   repository_url   = module.ecr.repository_url
#   subnet_ids       = module.networking.public_subnet_ids
#   ecs_tasks_sg_id  = module.networking.ecs_tasks_sg_id
#   target_group_arn = module.networking.target_group_arn
# }


# OUTPUTS

# output "app_url" {
#   value = "http://${module.networking_a.alb_dns_name}"
# }

output "DEBUG_public_subnets" {
  value = module.networking_a.public_subnet_ids
}

output "app_url" {
  value = "http://${module.networking_a.alb_dns_name}"
}


output "DEBUG_public_subnets_region_b" {
  value = module.networking_b.public_subnet_ids
}

output "app_url_region_b" {
  value = "http://${module.networking_b.alb_dns_name}"
}

# DIAGNOSTIC OUTPUTS
output "DEBUG_image_url_from_ecr" {
  value = module.ecr.repository_url
  description = "This is the URL Terraform is grabbing from the ECR module"
}

output "DEBUG_vpc_id" {
  value = module.networking_a.vpc_id
}

output "DEBUG_vpc_id_b" {
  value = module.networking_b.vpc_id 
}

# output "DEBUG_public_subnets" {
#   value = module.networking.public_subnet_ids
# }