# Creates all the infrastructure with Terraform (24 resources).
. "$PSScriptRoot\common.ps1"

Set-Location (Join-Path $ROOT "infra\environments\local")

Step "terraform init"
terraform init -input=false
Check "terraform init"

Step "terraform validate"
terraform validate
Check "terraform validate"

Step "terraform apply"
terraform apply -auto-approve -input=false
Check "terraform apply"

Step "Outputs"
terraform output
