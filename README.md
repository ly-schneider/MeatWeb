# About

This repository was created for a school project at GiBB. We ([@ly-schneider](https://github.com/ly-schneider), [@RO0OGER](https://github.com/RO0OGER), and [@ivogra](https://github.com/ivogra)) developed a project that automates the deployment of an EC2 instance configured as a Minecraft server using OpenTofu. The OpenTofu deployment also includes an RDS instance and a Lambda function. The Lambda function powers a Python-based Discord bot that saves Minecraft coordinates to the RDS instance.

# Setup

Create a `secrets.tfvars` file in the `opentofu` directory with the following values:

```
DISCORD_PUBLIC_KEY = ""
DB_HOST = ""
DB_PORT = 
DB_NAME = ""
DB_USER = ""
DB_PASSWORD = ""
```

Fill in the appropriate values before proceeding with the deployment.

# Deploy

### MacOS

Run the following script from the root directory:
`./deploy.sh`

### Windows

Run the following script from the root directory:
`.\deploy.ps1`