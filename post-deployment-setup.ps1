# post-deployment-setup.ps1
# PowerShell script to add Key Vault secrets after initial deployment

param(
    [switch]$WhatIf = $false
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "Starting post-deployment setup..." -ForegroundColor Green

try {
    # Get the resource group name and Key Vault name from Terraform outputs
    Write-Host "Retrieving Terraform outputs..." -ForegroundColor Yellow
    
    $RgName = terraform output -raw resource_group_name
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get resource group name from Terraform output"
    }
    
    $KvName = ""
    try {
        $KvName = terraform output -raw key_vault_name
    }
    catch {
        # If direct output doesn't exist, extract from Key Vault ID
        Write-Host "Extracting Key Vault name from ID..." -ForegroundColor Yellow
        $KvId = terraform output -raw key_vault_id
        $KvName = ($KvId -split '/')[-1]
    }
    
    Write-Host "Resource Group: $RgName" -ForegroundColor Cyan
    Write-Host "Key Vault: $KvName" -ForegroundColor Cyan
    
    # Function to add secrets to Key Vault
    function Add-KeyVaultSecret {
        param(
            [string]$SecretName,
            [string]$SecretValue,
            [string]$VaultName
        )
        
        Write-Host "Adding secret: $SecretName" -ForegroundColor Yellow
        
        if ($WhatIf) {
            Write-Host "WHATIF: Would add secret '$SecretName' to vault '$VaultName'" -ForegroundColor Magenta
            return $true
        }
        
        try {
            az keyvault secret set --vault-name $VaultName --name $SecretName --value $SecretValue --output none
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Success: Secret '$SecretName' added successfully" -ForegroundColor Green
                return $true
            }
            else {
                Write-Host "Error: Failed to add secret '$SecretName'" -ForegroundColor Red
                return $false
            }
        }
        catch {
            Write-Host "Error adding secret '$SecretName': $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }
    
    # Check if Azure CLI is logged in
    Write-Host "Checking Azure CLI authentication..." -ForegroundColor Yellow
    
    try {
        $accountInfo = az account show --query "name" --output tsv 2>$null
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrEmpty($accountInfo)) {
            throw "Not logged in"
        }
        Write-Host "Success: Logged in to Azure account: $accountInfo" -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Please log in to Azure CLI first:" -ForegroundColor Red
        Write-Host "  az login" -ForegroundColor White
        exit 1
    }
    
    Write-Host "Adding secrets to Key Vault..." -ForegroundColor Green
    
    # Generate a random suffix for the API key
    $randomSuffix = -join ((1..6) | ForEach-Object { '{0:x}' -f (Get-Random -Maximum 16) })
    
    # Add sample secrets
    $secretsAdded = 0
    $secretsTotal = 2
    
    if (Add-KeyVaultSecret -SecretName "database-connection-string" -SecretValue "Server=example.database.windows.net;Database=mydb;User=admin;" -VaultName $KvName) {
        $secretsAdded++
    }
    
    if (Add-KeyVaultSecret -SecretName "external-api-key" -SecretValue "sample-api-key-$randomSuffix" -VaultName $KvName) {
        $secretsAdded++
    }
    
    # Get Web App identity for Key Vault access policy
    Write-Host "Configuring Web App access to Key Vault..." -ForegroundColor Yellow
    
    $WebAppName = terraform output -raw webapp_name
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get web app name from Terraform output"
    }
    
    Write-Host "Getting Web App managed identity for: $WebAppName" -ForegroundColor Yellow
    
    if ($WhatIf) {
        Write-Host "WHATIF: Would configure Key Vault access policy for Web App '$WebAppName'" -ForegroundColor Magenta
    }
    else {
        try {
            $WebAppPrincipalId = az webapp identity show --name $WebAppName --resource-group $RgName --query "principalId" --output tsv
            
            if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrEmpty($WebAppPrincipalId)) {
                Write-Host "Setting Key Vault access policy for Web App..." -ForegroundColor Yellow
                
                az keyvault set-policy --name $KvName --object-id $WebAppPrincipalId --secret-permissions get list --output none
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Success: Key Vault access policy set for Web App" -ForegroundColor Green
                }
                else {
                    Write-Host "Error: Failed to set Key Vault access policy" -ForegroundColor Red
                }
            }
            else {
                Write-Host "Error: Could not retrieve Web App managed identity" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Error configuring Web App access: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Summary
    Write-Host ""
    Write-Host "Post-deployment setup completed!" -ForegroundColor Green
    Write-Host "Secrets added: $secretsAdded/$secretsTotal" -ForegroundColor Cyan
    
    if (-not $WhatIf) {
        Write-Host ""
        Write-Host "To update your Web App settings to reference Key Vault secrets, run:" -ForegroundColor Yellow
        $azCommand = "az webapp config appsettings set --name `"$WebAppName`" --resource-group `"$RgName`" --settings `"DATABASE_CONNECTION_STRING=@Microsoft.KeyVault(VaultName=$KvName;SecretName=database-connection-string)`" `"API_KEY=@Microsoft.KeyVault(VaultName=$KvName;SecretName=external-api-key)`""
        Write-Host $azCommand -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "You can verify the secrets were added by running:" -ForegroundColor Yellow
    Write-Host "az keyvault secret list --vault-name $KvName --output table" -ForegroundColor White
    
}
catch {
    Write-Host ""
    Write-Host "Script failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor DarkRed
    exit 1
}

Write-Host ""
Write-Host "Script completed successfully!" -ForegroundColor Green