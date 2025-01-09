#!/usr/bin/env bash
set -euo pipefail

# 1. Install required dependencies and create zip
echo "Installing dependencies..."
cd lambda-meatweb-01/app
mkdir -p package
pip3 install \
  --platform manylinux2014_x86_64 \
  --target=package \
  --implementation cp \
  --python-version 3.13 \
  --only-binary=:all: \
  --upgrade \
  -r requirements.txt

cd package
rm -r __pycache__
zip -r ../lambda_source_code.zip .
cd ..
zip lambda_source_code.zip main.py
chmod 644 lambda_source_code.zip

# 2. Move the zip
echo "Moving lambda_source_code.zip..."
mv lambda_source_code.zip ../../opentofu/
cd ../../opentofu/

# 3. Deploy using OpenTofu
echo "Initializing and applying Terraform/OpenTofu..."
tofu init
tofu plan -var-file="secrets.tfvars"
tofu apply -var-file="secrets.tfvars" -auto-approve

echo "Deployment complete!"
