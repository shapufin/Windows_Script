# Define ports required for Active Directory and RPC communication
$fixedPorts = @(
    53,    # DNS (TCP/UDP)
    88,    # Kerberos authentication (TCP/UDP)
    135,   # RPC Endpoint Mapper (TCP)
    389,   # LDAP (TCP/UDP)
    445,   # SMB (TCP)
    464,   # Kerberos password change (TCP/UDP)
    636,   # LDAP over SSL (TCP)
    3268,  # Global Catalog (TCP)
    3269   # Global Catalog over SSL (TCP)
)

$dynamicPorts = 49152..65535  # Dynamic RPC ports (TCP)

# Allow ICMP (Ping) traffic
Write-Host "Allowing ICMP (Ping) traffic..."
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Action Allow -Direction Inbound -Profile Domain,Private,Public

# Add firewall rules for fixed ports
foreach ($port in $fixedPorts) {
    Write-Host "Allowing fixed port $port..."
    New-NetFirewallRule -DisplayName "Allow Port $port" -Protocol TCP -LocalPort $port -Action Allow -Direction Inbound -Profile Domain,Private,Public
}

# Add firewall rules for dynamic RPC ports
Write-Host "Allowing dynamic RPC ports (49152-65535)..."
New-NetFirewallRule -DisplayName "Allow Dynamic RPC Ports" -Protocol TCP -LocalPort 49152-65535 -Action Allow -Direction Inbound -Profile Domain,Private,Public

# Add UDP rules for DNS and Kerberos
Write-Host "Allowing UDP ports for DNS and Kerberos..."
New-NetFirewallRule -DisplayName "Allow DNS (UDP)" -Protocol UDP -LocalPort 53 -Action Allow -Direction Inbound -Profile Domain,Private,Public
New-NetFirewallRule -DisplayName "Allow Kerberos (UDP) - 88" -Protocol UDP -LocalPort 88 -Action Allow -Direction Inbound -Profile Domain,Private,Public
New-NetFirewallRule -DisplayName "Allow Kerberos (UDP) - 464" -Protocol UDP -LocalPort 464 -Action Allow -Direction Inbound -Profile Domain,Private,Public

Write-Host "Firewall rules for Active Directory and RPC communication have been configured successfully."