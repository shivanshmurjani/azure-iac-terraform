#!/bin/bash

# post-deployment-setup.sh
# Script to add Key Vault secrets after initial deployment

set -e  # Exit on any error

echo "Starting post-deployment setup..."

# Get the resource group name and Key Vault name from Terraform outputs
RG_NAME=$(terraform output -raw resource_group_name)
KV_NAME=$(terraform output -raw key_vault_name 2>/dev/null || echo "")

if [ -z "$KV_NAME" ]; then
    # Extract Key Vault name from Key Vault ID if direct output doesn't exist
    KV_ID=$(terraform output -raw key_vault_id)
    KV_NAME=$(echo $KV_ID | sed 's|.*/||')
fi

echo "Resource Group: $RG_NAME"
echo "Key Vault: $KV_NAME"

# Function to add secrets to Key Vault
add_keyvault_secret() {
    local secret_name=$1
    local secret_value=$2
    
    echo "Adding secret: $secret_name"
    az keyvault secret set \
        --vault-name "$KV_NAME" \
        --name "$secret_name" \
        --value "$secret_value" \
        --output none
    
    if [ $? -eq 0 ]; then
        echo "✓ Secret '$secret_name' added successfully"
    else
        echo "✗ Failed to add secret '$secret_name'"
        return 1
    fi
}

# Check if Azure CLI is logged in
if ! az account show &>/dev/null; then
    echo "Please log in to Azure CLI first:"
    echo "az login"
    exit 1
fi

echo "Adding secrets to Key Vault..."

# Add sample secrets
add_keyvault_secret "database-connection-string" "Server=example.database.windows.net;Database=mydb;User=admin;"
add_keyvault_secret "external-api-key" "sample-api-key-$(openssl rand -hex 6)"

# Get Web App identity for Key Vault access policy
WEBAPP_NAME=$(terraform output -raw webapp_name)
echo "Getting Web App managed identity..."

WEBAPP_PRINCIPAL_ID=$(az webapp identity show \
    --name "$WEBAPP_NAME" \
    --resource-group "$RG_NAME" \
    --query principalId \
    --output tsv)

if [ -n "$WEBAPP_PRINCIPAL_ID" ]; then
    echo "Setting Key Vault access policy for Web App..."
    az keyvault set-policy \
        --name "$KV_NAME" \
        --object-id "$WEBAPP_PRINCIPAL_ID" \
        --secret-permissions get list \
        --output none
    
    if [ $? -eq 0 ]; then
        echo "✓ Key Vault access policy set for Web App"
    else
        echo "✗ Failed to set Key Vault access policy"
    fi
else
    echo "✗ Could not retrieve Web App managed identity"
fi

echo "Post-deployment setup completed!"
echo ""
echo "You can now update your Web App settings to reference Key Vault secrets:"
echo "az webapp config appsettings set \\"
echo "    --name \"$WEBAPP_NAME\" \\"
echo "    --resource-group \"$RG_NAME\" \\"
echo "    --settings \\"
echo "    \"DATABASE_CONNECTION_STRING=@Microsoft.KeyVault(VaultName=$KV_NAME;SecretName=database-connection-string)\" \\"
echo "    \"API_KEY=@Microsoft.KeyVault(VaultName=$KV_NAME;SecretName=external-api-key)\""