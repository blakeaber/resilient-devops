variable "profile" {
  description = "Name of your profile inside ~/.aws/credentials"
}

variable "application_name" {
  description = "Name of your application"
}

variable "application_description" {
  description = "Sample application based on Elastic Beanstalk & Docker"
}

variable "application_environment" {
  description = "Deployment stage e.g. 'staging', 'production', 'test', 'integration'"
}

variable "region" {
  default     = "us-east-1"
  description = "Defines where your app should be deployed"
}

variable "rds_endpoint" {
  description = "rds string for your db"
}

variable "rds_user" {
  description = "rds user for your db"
}

variable "rds_password" {
  description = "rds password for your db"
}

variable "rds_port" {
  description = "rds port for your db"
}

variable "auto_scalling_max_size" {
  default     = "5"
  description = "auto scalling max size or capacity for asg"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "ec2 instance type for docker host"
}


variable "ssl_certificate_arn" {
  description = "ssl arn to make alb https, critical for app functioning"
 }
