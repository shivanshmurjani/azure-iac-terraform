# Azure IAC Terraform Repository

This repository demonstrates how to deploy secure Azure infrastructure using Terraform, with automated provisioning via GitHub Actions.

---

## Project Structure

```
azure-iac-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf  # Configure backend here
├── .gitignore
├── README.md
└── .github/workflows/
    ├── deploy.yml
    └── destroy.yml
```

---

## Initial Backend Setup

Terraform requires a backend to store state. Follow these steps:

### 1. Generate Random Names (Optional)

```powershell
# Generate a random 6-character suffix
$rand = -join ((65..90) + (97..122) | Get-Random -Count 2 | % {[char]$_})

# Define names using the random suffix
$rgName        = "platform-rg-$rand"
$storageName   = "tfstate$rand"
$containerName = "tfstate$rand"

Write-Host "Resource Group: $rgName"
Write-Host "Storage Account: $storageName"
Write-Host "Blob Container: $containerName"
```

### 2. Create Resource Group

```powershell
az group create --name $rgName --location centralindia
```

### 3. Create Storage Account

```powershell
az storage account create `
  --name $storageName `
  --resource-group $rgName `
  --location centralindia `
  --sku Standard_LRS `
  --kind StorageV2 `
  --enable-hierarchical-namespace false
```

### 4. Create Blob Container

```powershell
az storage container create `
  --name $containerName `
  --account-name $storageName
```

### 5. Update `backend.tf`

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "$rgName"
    storage_account_name = "$storageName"
    container_name       = "$containerName"
    key                  = "azure-iac-terraform.tfstate"
  }
}
```

> Tip: Use environment variables or GitHub Actions secrets to make backend dynamic in CI/CD pipelines.

---

## Deploying Infrastructure Locally

1. Initialize Terraform:

```bash
terraform init
```

2. Validate configuration:

```bash
terraform validate
```

3. Plan changes:

```bash
terraform plan
```

4. Apply infrastructure:

```bash
terraform apply -auto-approve
```

5. Check outputs:

```bash
terraform output
```

---

## GitHub Actions Deployment

### 1. Workflow: `deploy.yml`

* Triggered on push to `main`
* Steps:

  * Checkout code
  * Setup Terraform
  * Azure login using GitHub secrets (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`)
  * Terraform format, init, validate, plan, and apply

### 2. Workflow: `destroy.yml`

* Triggered on `workflow_dispatch` (manual)
* Requires input `confirm_destroy` with value `destroy`
* Steps:

  * Checkout code
  * Setup Terraform
  * Azure login
  * Terraform init
  * Terraform destroy

> This ensures automated creation and destruction of infrastructure via GitHub Actions.

---

## Security Hardening

* All resources deployed inside a private VNet
* Disable public access for Storage Account (`public_network_access_enabled = false`)
* Use VNet Integration for Web App
* Private Endpoints for services where applicable
* Avoid public IPs
* Restrict access via NSGs
* Optional: Use Azure Key Vault to manage secrets securely

---

## Variables & Outputs

* `variables.tf` contains configurable variables
* `outputs.tf` provides useful outputs like resource names and URLs

---

## Notes

* Ensure the backend resource group and storage account exist before running Terraform
* Use random suffixes to prevent name collisions
* Keep sensitive credentials in GitHub Secrets or local environment variables

---

## References

* [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [GitHub Actions](https://docs.github.com/en/actions)
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
