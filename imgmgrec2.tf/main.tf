#Data Sources
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "skynet-common-tf-state-terraformstatebucket-cgekjwkwrwip"
    key    = "env:/common/vpc.tfstate"
    region = "us-east-1"
  }
}


#EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.vpc.outputs.privatesubnet1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = "TOPAccountKey"
  iam_instance_profile = aws_iam_instance_profile.EC2_Profile.id
  tags = {
    Name = "${var.environment}-${var.namespace}-Web"
  }
}

#EC2 Key Pair Creation
#resource "aws_key_pair" "deployer" {
#  key_name   = "deployer-key"
#  public_key = file("~/.ssh/id_rsa.pub")
#}

#EC2 Instance Profile
resource "aws_iam_instance_profile" "EC2_Profile" {
  name = "${terraform.workspace}-EC2-Instance-Profile"
  role = aws_iam_role.ec2role.name
}

#EC2 IAM Role
resource "aws_iam_role" "ec2role" {
  name = "${terraform.workspace}-EC2-Instance-Role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]
  inline_policy {
    name = "ec2s3accesspolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ],
          Effect = "Allow",
          Resource = [
            "${aws_s3_bucket.imgmgrs3bucket}"
          ]
        }
      ]
    })
  }
  tags = {
    tag-key = "tag-value"
  }
}

#EC2 Security Group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.id

  ingress {
    
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["98.186.165.150/32"]
      ipv6_cidr_blocks = ["2600:8803:7c80:9f00:6170:661e:c401:142f/128"]
    }
  

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow_SSH"
  }
}

#S3 Bucket Creation
resource "aws_s3_bucket" "imgmgrs3bucket" {
  bucket = "${var.environment}_${var.namespace}_bucket_fmdidgad1"
  acl    = "private"
}