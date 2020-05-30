# AWS Elastic Beanstalk with Docker Deploy Setup

Purpose of this repo is to document and simplify deployment & setup process of Docker-based applications on AWS Elastic Beanstalk.

### Prerequisities
- AWS IAM Role with access to IAM, EC2, ACM, ROUTE 53, Beanstalk & Elastic Container Registry/Engine and it's access & secret keys. Profile must be set inside `~/.aws/credentials` directory.
- Terraform
- Docker
- ACM ```ARN``` for certificate
- RDS DB connection string, user, password and port
- route53 https certified website domain with the cert above 

If you don't have your AWS credentials set as ENV variables:
```
 $ export AWS_ACCOUNT_ID=XX677677XXXX 

 $ export AWS_ACCESS_KEY_ID=AKIAIXEXIX5JW5XM6XXX 

 $ export AWS_SECRET_ACCESS_KEY=XXXxmxxXlxxbA3vgOxxxxCk+uXXXXOrdmpC/oXxx

```

### Contents of repo
 - ```Dockerrun.aws.json``` - AWS Beanstalk standard task definition. Tells Beanstalk which image from ECR it should use
 - ```deploy.sh``` - script for deploying applications. App must be first set up
 - ```Dockerfile``` - You will use to build your image, please change this to your need (make sure the FROM part is always the first line of the script)
 - ```*.tf``` files - Terraform infrastructure definition written in HCL (HashiCorp Configuration Language)
 - ```clean.sh``` - script for cleaning temporary files

### Setup
1. Use the terraform.tfvars for fill in information that is needed for variables.tf file. Do not edit variables.tf file. terraform.tfvars will stay local and in action of a git push no update on it should be made. Otherwise a risk for exposing credentials
2. Run ```terraform init```
```
  NOTE: If you have the A records of your site: i.e. `www.example.com` or example.com. Get the following from Route53
  - ZONEID
  - RECORDNAME i.e `example.com` or `www.example.com`
  - TYPE i.e in this case if A
  - SET-IDENTIFIER is optional

  Command a. below is for `www.example.com`
  Command b. below is for `example.com`
  
  Run the following before proceeding
  a. ```terraform import aws_route53_record.www ZONEID_RECORDNAME_TYPE_SET-IDENTIFIER```
  b. ```terraform import aws_route53_record.none_www ZONEID_RECORDNAME_TYPE_SET-IDENTIFIER```

  Example:
  terraform import aws_route53_record.www Z09450532HJQAQAXDrfcV_www.example.com_A
```

3. Run ```terraform plan -out plan.tfplan```
  - Fill out Name, Description & environment
  - Profile is name of your profile inside `~/.aws/credentials` file (Standard AWS way). Default profile is called `default`. You can insert many profiles inside `credentials` file.
4. Run ```terraform apply plan.tfplan``` - this may take up to 15 minutes

Alternatively you can place variables inside `terraform.tfvars` file instead of pasting them into CLI input.

### Rollbacking setup
```
terraform destroy
```

### Manual deployment (i.e $(git show -s --format=%H) is how you get the git commit-sha)
```
./deploy.sh <appname> <environment> <region> <commit_sha>
```
For example:
```
./deploy.sh resilient-ai staging us-east-1 $(git show -s --format=%H)
```
Now let us Deploy...
```
./deploy.sh my-app-name staging us-east-1 $(git show -s --format=%H)
```

### Common Errors
Docker may fail to login to ecr depending on the machine and aws cli version in use. Usually because of docker login. If so please try this locally and try again. This will force docker to login to aws ecr for you. Then re-rin deploy.sh
```
$ $(aws ecr get-login --profile default | awk '{ print "sudo", $1, $2, $3, $4, $5, $6, $9}')

```

### Automatic deployment
Edit your `circle.yml` file to invoke `deploy.sh` script in `post.test` or `deploy` hook. Don't forget to fill out ENV variables in CircleCI setup.
