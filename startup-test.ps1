# security-test.ps1 - Complete security validation script
$ErrorActionPreference = "Continue"

Write-Host "Starting comprehensive security testing..." -ForegroundColor Green

# Get resource names
$RgName = terraform output -raw resource_group_name
$WebAppName = terraform output -raw webapp_name  
$StorageName = terraform output -raw storage_account_name
$KeyVaultName = terraform output -raw key_vault_name

Write-Host "Testing Resource Group: $RgName" -ForegroundColor Cyan

# Test 1: Infrastructure Status
Write-Host "`n=== Infrastructure Status Tests ===" -ForegroundColor Yellow
$webAppState = az webapp show --name $WebAppName --resource-group $RgName --query "state" -o tsv
Write-Host "Web App State: $webAppState" -ForegroundColor $(if($webAppState -eq "Running") {"Green"} else {"Red"})

# Test 2: Security Controls
Write-Host "`n=== Security Controls Tests ===" -ForegroundColor Yellow
$storagePublicAccess = az storage account show --name $StorageName --resource-group $RgName --query "publicNetworkAccess" -o tsv
Write-Host "Storage Public Access: $storagePublicAccess" -ForegroundColor $(if($storagePublicAccess -eq "Disabled") {"Green"} else {"Red"})

$kvPublicAccess = az keyvault show --name $KeyVaultName --resource-group $RgName --query "properties.publicNetworkAccess" -o tsv
Write-Host "Key Vault Public Access: $kvPublicAccess" -ForegroundColor $(if($kvPublicAccess -eq "false") {"Green"} else {"Red"})

# Test 3: Private Endpoints
Write-Host "`n=== Private Endpoints Tests ===" -ForegroundColor Yellow
$kvEndpointStatus = az network private-endpoint show --name "pe-$KeyVaultName" --resource-group $RgName --query "privateLinkServiceConnections[0].privateLinkServiceConnectionState.status" -o tsv
Write-Host "Key Vault Endpoint Status: $kvEndpointStatus" -ForegroundColor $(if($kvEndpointStatus -eq "Approved") {"Green"} else {"Red"})

$storageEndpointStatus = az network private-endpoint show --name "pe-$StorageName" --resource-group $RgName --query "privateLinkServiceConnections[0].privateLinkServiceConnectionState.status" -o tsv  
Write-Host "Storage Endpoint Status: $storageEndpointStatus" -ForegroundColor $(if($storageEndpointStatus -eq "Approved") {"Green"} else {"Red"})

# Test 4: Public Access (Should Fail)
Write-Host "`n=== Public Access Tests (Should Fail) ===" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "https://$WebAppName.azurewebsites.net" -TimeoutSec 5 | Out-Null
    Write-Host "Web App Public Access: ACCESSIBLE (SECURITY RISK!)" -ForegroundColor Red
} catch {
    Write-Host "Web App Public Access: BLOCKED (SECURE)" -ForegroundColor Green
}

Write-Host "`nSecurity testing completed!" -ForegroundColor Green