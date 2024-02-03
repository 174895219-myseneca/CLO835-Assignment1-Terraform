# Terraform Configuration for CLO835 Course Assignment 1
This repository contains Terraform code to provision the following AWS resources:
- Amazon Elastic Container Registry (ECR)
- An Amazon EC2 instance configured with Docker
- An Application Load Balancer that directs traffic to three separate containers hosted on the EC2 instance
- All necessary supplementary components such as security groups, target groups, and listener rules


### Steps to Deploy the Infrastructure
Use the following Terraform commands to initialize, validate, plan, and apply the infrastructure setup:
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Steps to Teardown the Infrastructure
To remove all resources created by Terraform, execute:
```bash
terraform destroy
```
