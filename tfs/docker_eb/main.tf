# Configure AWS Credentials & Region
provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

# S3 Bucket for storing Elastic Beanstalk task definitions
resource "aws_s3_bucket" "ng_beanstalk_deploys" {
  bucket = "${var.application_name}-deployments-resilient-ai"
  region = "${var.region}"
}

# Elastic Container Repository for Docker images
resource "aws_ecr_repository" "ng_container_repository" {
  name = "${var.application_name}"
}

# Beanstalk instance profile
resource "aws_iam_instance_profile" "ng_beanstalk_ec2" {
  name  = "ng-beanstalk-ec2-user"
  roles = ["${aws_iam_role.ng_beanstalk_ec2.name}"]
}

resource "aws_iam_role" "ng_beanstalk_ec2" {
  name = "ng-beanstalk-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Beanstalk EC2 Policy
# Overriding because by default Beanstalk does not have a permission to Read ECR
resource "aws_iam_role_policy" "ng_beanstalk_ec2_policy" {
  name = "ng_beanstalk_ec2_policy_with_ECR"
  role = "${aws_iam_role.ng_beanstalk_ec2.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "elasticbeanstalk:*",
        "ds:CreateComputer",
        "ds:DescribeDirectories",
        "ec2:DescribeInstanceStatus",
        "logs:*",
        "ssm:*",
        "xray:*",
        "sqs:*"
        "ec2messages:*",
        "ecr:*",
        "dynamodb:*",
        "ecs:*",
        "iam:*",
        "rds:*",
        "sns:*",
        "autoscaling:*",
        "elasticloadbalancing:*",
        "codebuild:*",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Beanstalk Application
resource "aws_elastic_beanstalk_application" "ng_beanstalk_application" {
  name        = "${var.application_name}"
  description = "${var.application_description}"
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "ng_beanstalk_application_environment" {
  name                = "${var.application_name}-${var.application_environment}"
  application         = "${aws_elastic_beanstalk_application.ng_beanstalk_application.name}"
  solution_stack_name = "64bit Amazon Linux 2 v3.0.1 running Docker"
  tier                = "WebServer"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"

    value = "${var.instance_type}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"

    value = "${var.auto_scalling_max_size}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.ng_beanstalk_ec2.name}"
  }
  
  # For rds information in the near future a use of AWS SDK to call them from application layer will reduce attack vector
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_ENDPOINT"

    value = "${var.rds_endpoint}"
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USER"

    value = "${var.rds_user}"
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"

    value = "${var.rds_port}"
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USER"

    value = "${var.rds_password}"
  }
  
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"

    value = "Any"
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"

    value = "LoadBalanced"
  }
  
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"

    value = "true"
  }
  
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"

    value = "true"
  }
  
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"

    value = "application"
  }
  
}

# Create a new application load balancer
resource "aws_elb" "alb" {
    name               = "${var.elb_alb}"
    #availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
    enable_http2       = true

    listener {
      instance_port     = "${var.instance_port}"
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }

    listener {
      instance_port      = "${var.instance_port}"
      instance_protocol  = "http"
      lb_port            = 443
      lb_protocol        = "https"
      ssl_certificate_id = "${var.ssl_certificate_id}"
    }

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      target              = "HTTP:${var.instance_port}/"
      interval            = 30
    }

    # instances                   = ["${aws_instance.foo.id}"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400

    tags = {
      Name = "resillient-terraform-elb-alb"
    }
  }
