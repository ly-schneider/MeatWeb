terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc_meatweb_01" {
  source = "./modules/vpc"

  cidr_block           = "172.30.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-MeatWeb-01"
  }
}

module "subnet_meatweb_01" {
  source = "./modules/subnet"

  vpc_id            = module.vpc_meatweb_01.id
  cidr_block        = "172.30.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet-MeatWeb-01"
  }
}

module "subnet_meatweb_02" {
  source = "./modules/subnet"

  vpc_id            = module.vpc_meatweb_01.id
  cidr_block        = "172.30.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet-MeatWeb-02"
  }
}

module "subnet_meatweb_03" {
  source = "./modules/subnet"

  vpc_id            = module.vpc_meatweb_01.id
  cidr_block        = "172.30.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subnet-MeatWeb-03"
  }
}

module "igw_meatweb_01" {
  source = "./modules/internet_gateway"

  vpc_id = module.vpc_meatweb_01.id

  tags = {
    Name = "IGW-MeatWeb-01"
  }
}

module "rt_meatweb_01" {
  source = "./modules/route_table"

  vpc_id = module.vpc_meatweb_01.id

  cidr_block = "0.0.0.0/0"
  gateway_id = module.igw_meatweb_01.id

  tags = {
    Name = "RT-MeatWeb-01"
  }
}

module "rta_meatweb_01" {
  source = "./modules/route_table_association"

  subnet_id      = module.subnet_meatweb_01.id
  route_table_id = module.rt_meatweb_01.id
}

module "rta_meatweb_02" {
  source = "./modules/route_table_association"

  subnet_id      = module.subnet_meatweb_02.id
  route_table_id = module.rt_meatweb_01.id
}

module "rta_meatweb_03" {
  source = "./modules/route_table_association"

  subnet_id      = module.subnet_meatweb_03.id
  route_table_id = module.rt_meatweb_01.id
}

module "sg_ec2_meatweb_01" {
  source = "./modules/security_group"

  name        = "SG-EC2-MeatWeb-01"
  description = "EC2 security group"
  vpc_id      = module.vpc_meatweb_01.id
  ingress_rules = [
    {
      description = "Minecraft"
      from_port   = 25565
      to_port     = 25565
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "SSH/SFTP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "SG-EC2-MeatWeb-01"
  }
}

module "sg_rds_meatweb_01" {
  source = "./modules/security_group"

  name        = "SG-RDS-MeatWeb-01"
  description = "RDS security group"
  vpc_id      = module.vpc_meatweb_01.id
  ingress_rules = [
    {
      description = "PostgreSQL"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "SG-RDS-MeatWeb-01"
  }
}

module "sg_lambda_meatweb_01" {
  source = "./modules/security_group"

  name        = "SG-Lambda-MeatWeb-01"
  description = "Lambda security group"
  vpc_id      = module.vpc_meatweb_01.id
  ingress_rules = [
    {
      description = "All traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "SG-Lambda-MeatWeb-01"
  }
}

module "subnetgroup_meatweb_01" {
  source = "./modules/subnet_group"

  name       = "subnetgroup-rds-meatweb-01"
  subnet_ids = [module.subnet_meatweb_02.id, module.subnet_meatweb_03.id]

  tags = {
    Name = "SubnetGroup-RDS-MeatWeb-01"
  }
}

module "rds_meatweb_01" {
  source               = "./modules/rds"
  db_subnet_group_name = module.subnetgroup_meatweb_01.name
  identifier           = "rds-meatweb-01"
  instance_class       = "db.t4g.small"
  engine               = "postgres"
  engine_version       = "16.3"
  db_name              = var.DB_NAME
  username             = var.DB_USER
  password             = var.DB_PASSWORD
  vpc_security_group_ids = [module.sg_rds_meatweb_01.id]
  publicly_accessible  = true
  port                 = var.DB_PORT

  parameter_group_name = "default.postgres16"
  option_group_name    = "default:postgres-16"

  storage_encrypted    = true
  storage_type         = "gp3"
  deletion_protection  = false
  allocated_storage    = 20

  multi_az             = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  backup_window              = "02:00-03:00"
  maintenance_window         = "sat:03:00-sat:04:00"
  auto_minor_version_upgrade = true
  skip_final_snapshot        = true
  apply_immediately          = false

  tags = {
    Name = "RDS-MeatWeb-01"
  }
}

module "keypair_ec2_meatweb_01" {
  source = "./modules/key_pair"

  key_name = "key-pair-ec2-meatweb-01"
  public_key_path = "~/.ssh/id_rsa.pub"

  tags = {
    Name = "KeyPair-EC2-MeatWeb-01"
  }
}

module "ec2_meatweb_01" {
  source = "./modules/ec2"

  ami                         = "ami-079cb33ef719a7b78"
  instance_type               = "t2.large"
  subnet_id                   = module.subnet_meatweb_01.id
  vpc_security_group_ids      = [module.sg_ec2_meatweb_01.id]
  associate_public_ip_address = true
  key_name                    = module.keypair_ec2_meatweb_01.key_name

  volume_size                 = 80
  volume_type                 = "gp3"
  delete_on_termination       = true

  tags = {
    Name = "EC2-MeatWeb-01"
  }
}

module "eip_ec2_meatweb_01" {
  source = "./modules/eip"

  instance = module.ec2_meatweb_01.id
  domain   = "vpc"

  tags = {
    Name = "EIP-EC2-MeatWeb-01"
  }
}

module "lambda_meatweb_01" {
  source = "./modules/lambda"

  role          = "LabRole"
  description   = "Discord Bot for MeatWeb"
  function_name = "lambda-meatweb-01"
  handler       = "main.handler"
  runtime       = "python3.13"
  file_path     = "${path.module}/lambda_source_code.zip"
  publish       = false

  environment_variables = {
    DISCORD_PUBLIC_KEY = var.DISCORD_PUBLIC_KEY
    DB_HOST = var.DB_HOST
    DB_PORT = var.DB_PORT
    DB_USER = var.DB_USER
    DB_PASSWORD = var.DB_PASSWORD
    DB_NAME = var.DB_NAME
  }

  tags = {
    Name = "Lambda-MeatWeb-01"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
