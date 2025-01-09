# Setup:

Create a `secrets.tfvars` file in the `opentofu` directory with the `discord_public_key` value like this:

```
discord_public_key = "KEY_CONTENT_HERE"
```

# Deploy (MacOS):

Install all the required dependencies and create a zip file:
```zsh
cd lambda-meatweb-01/app
mkdir package
pip3 install --platform manylinux2014_x86_64 --target=package --implementation cp --python-version 3.13 --only-binary=:all: --upgrade -r requirements.txt
cd package
rm -r __pycache__
zip -r ../lambda_source_code.zip .
cd ..
zip lambda_source_code.zip main.py
chmod 644 lambda_source_code.zip 
```

Move the zip:
```zsh
mv lambda_source_code.zip ../../opentofu/
cd ../../opentofu/
```

Deploy:
```zsh
tofu init
tofu plan -var-file="secrets.tfvars"
tofu apply -var-file="secrets.tfvars"
```