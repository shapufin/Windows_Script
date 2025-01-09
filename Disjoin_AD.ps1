# Import and load environment variables
$scriptPath = $PSScriptRoot
$envLoader = Join-Path $scriptPath "Load-Environment.ps1"
. $envLoader
Load-DotEnv

# Get values from environment variables
$DomainName = $env:DOMAIN_NAME
if (-not $DomainName) {
    Write-Error "Domain name not found in environment variables"
    exit 1
}

$WorkgroupName = $env:WORKGROUP_NAME
if (-not $WorkgroupName) {
    Write-Error "Workgroup name not found in environment variables"
    exit 1
}

$DomainAdminUser = $env:DOMAIN_ADMIN_USER
if (-not $DomainAdminUser) {
    Write-Error "Domain admin user not found in environment variables"
    exit 1
}

$DomainAdminPassword = $env:DOMAIN_ADMIN_PASSWORD
if (-not $DomainAdminPassword) {
    Write-Error "Domain admin password not found in environment variables"
    exit 1
}

# Convert password to secure string
$SecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force

# Create the credential object
$Credential = New-Object System.Management.Automation.PSCredential($DomainAdminUser, $SecurePassword)

# Remove the computer from the domain and join a workgroup
Write-Host "Removing the computer from the domain..."
Remove-Computer -Credential $Credential -WorkgroupName $WorkgroupName -Force -Restart

Write-Host "The computer has been removed from the domain and is now part of the workgroup '$WorkgroupName'. The system will restart."
