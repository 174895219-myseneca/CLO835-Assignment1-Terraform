

#----------------------------------------------------------
# ACS730 - Week 3 & 4 - Terraform Introduction
#
# Build EC2 Instances
#
#----------------------------------------------------------


provider "aws" {
  region = "us-east-1"
}


# Define an ECR repository
resource "aws_ecr_repository" "ecr_assignment1" {
  name                 = "clo835-assignment1-ecr" # Name your repository
  image_tag_mutability = "MUTABLE"
}

# # Define an IAM policy that grants access to the ECR
# resource "aws_iam_policy" "ecr_policy" {
#   name        = "ecr_policy"
#   description = "A policy that grants access to ECR."

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "ecr:BatchCheckLayerAvailability",
#         ],
#         Effect   = "Allow",
#         Resource = aws_ecr_repository.ecr_assignment1.arn
#       },
#     ],
#   })
# }

# # Create an IAM role for the EC2 instance
# resource "aws_iam_role" "ec2_role" {
#   name = "ec2_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#       },
#     ],
#   })
# }

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "ec2_ecr_policy_attachment" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = aws_iam_policy.ecr_policy.arn
# }

# # Define the instance profile to attach to the EC2 instance
# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "ec2_instance_profile"
#   role = aws_iam_role.ec2_role.name
# }


data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}



data "aws_availability_zones" "available" {
  state = "available"
}

# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "LabInstanceProfile"
# }

resource "aws_instance" "my_amazon" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.week4_assignment1.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true
  security_groups             = [aws_security_group.web_sg.id]
  # iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  iam_instance_profile        = "LabInstanceProfile"
  user_data                   = file("${path.module}/install_docker.sh")
  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-EC2-Web-Application"
    }
  )
}



resource "aws_key_pair" "week4_assignment1" {
  key_name   = "week4_assignment1"
  public_key = file("week4.pub")
}
