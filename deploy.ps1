# Deploy.ps1

# Enable strict mode
Set-StrictMode -Version Latest

# Function to check for errors
function Handle-Error {
    if (-not $?) {
        Write-Error "An error occurred. Exiting."
        exit 1
    }
}

# 1. Install required dependencies and create zip
Write-Host "Installing dependencies..."
Set-Location -Path "lambda-meatweb-01\app"
New-Item -ItemType Directory -Path package -Force | Out-Null

# Install dependencies using pip
$pipCommand = "pip3"
$pipArgs = @(
    "install",
    "--platform", "manylinux2014_x86_64",
    "--target=package",
    "--implementation", "cp",
    "--python-version", "3.13",
    "--only-binary=:all:",
    "--upgrade",
    "-r", "requirements.txt"
)

& $pipCommand @pipArgs
Handle-Error

Set-Location -Path package
Remove-Item -Recurse -Force __pycache__ -ErrorAction SilentlyContinue
Compress-Archive -Path * -DestinationPath ..\lambda_source_code.zip
Handle-Error
Set-Location -Path ..
Compress-Archive -Path main.py -Update -DestinationPath lambda_source_code.zip
Handle-Error

# Set file permissions
(Get-Item lambda_source_code.zip).Attributes = "Normal"

# 2. Move the zip
Write-Host "Moving lambda_source_code.zip..."
Move-Item -Path lambda_source_code.zip -Destination "..\..\opentofu\" -Force
Handle-Error
Set-Location -Path "..\..\opentofu"

# 3. Deploy using OpenTofu
Write-Host "Initializing and applying Terraform/OpenTofu..."
& tofu init
Handle-Error
& tofu plan -var-file="secrets.tfvars"
Handle-Error
& tofu apply -var-file="secrets.tfvars" -auto-approve
Handle-Error

Write-Host "Deployment complete!"
