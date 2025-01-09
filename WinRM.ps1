# Import and load environment variables
$scriptPath = $PSScriptRoot
$envLoader = Join-Path $scriptPath "Load-Environment.ps1"
. $envLoader
Load-DotEnv

# Get allowed IPs from environment variable
$allowedIPs = $env:ALLOWED_IPS
if (-not $allowedIPs) {
    Write-Error "Allowed IPs not found in environment variables"
    exit 1
}
$allowedIPs = $allowedIPs -split ',' | ForEach-Object { $_.Trim() }

# Enable WinRM
Enable-PSRemoting -Force

# Allow the listed IPs in the firewall for WinRM communication on HTTP and HTTPS ports
foreach ($ip in $allowedIPs) {
    # Allow inbound WinRM traffic on port 5985 (HTTP) and 5986 (HTTPS) for each IP address
    New-NetFirewallRule -DisplayName "Allow WinRM from $ip (HTTP)" -Direction Inbound -Protocol TCP -LocalPort 5985 -RemoteAddress $ip -Action Allow -Profile Any
    New-NetFirewallRule -DisplayName "Allow WinRM from $ip (HTTPS)" -Direction Inbound -Protocol TCP -LocalPort 5986 -RemoteAddress $ip -Action Allow -Profile Any
}

# Configure TrustedHosts for WinRM to allow connections from the specified IPs
$trustedHosts = $allowedIPs -join ","
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $trustedHosts -Force

# Ensure the service is listening for all IPs
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item WSMan:\localhost\Service\AllowBasic -Value $true

Write-Output "WinRM configured to allow full access from IPs: $($allowedIPs -join ', ')"
