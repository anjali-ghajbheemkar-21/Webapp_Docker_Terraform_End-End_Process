variable "prefix" {
  default = "xyz"
}

variable "project" {
  default = "xyz_dockerised"
}

variable "contact" {
  default = "xyz@xyz.com"
}

variable "db_username" {
  description = "Username for the RDS postgres instance"
}

variable "db_password" {
  description = "Password for the RDS postgres instance"
}

variable "bastion_key_name" {
  default = "xyzm-website-devops-bastion"
}

variable "ecr_image_api" {
  description = "ECR image for API"
  default     = "update_ecr_image_path_here"
}

variable "ecr_image_proxy" {
  description = "ECR image for proxy"
  default     = "update_ecr_image_proxy_path_here"
}

variable "django_secret_key" {
  description = "Secret key for Django app"
}
variable "dns_zone_name" {
  description = "Domain name"
  default     = "xyz.com"
}

variable "subdomain" {
  description = "Subdomain per environment"
  type        = map(string)
  default = {
    production = "www"
    staging    = "api.staging"
    dev        = "api.dev"
  }
}
