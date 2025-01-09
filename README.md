# Windows Active Directory Management Scripts

A collection of PowerShell scripts for managing Active Directory environments, including domain operations, WinRM configuration, and AD replication monitoring.

## Prerequisites

- Windows Server with PowerShell 5.1 or later
- Administrative privileges
- Active Directory Domain Services installed (for AD-related scripts)

## Setup Instructions

1. Clone the repository:
```powershell
git clone https://github.com/shapufin/Windows_Script.git
```

2. Create a `.env` file in the root directory:
   - Copy `.env.example` to `.env`
   - Fill in your environment-specific values

```powershell
Copy-Item .env.example .env
```

3. Edit the `.env` file with your specific configuration:
```env
# Domain Configuration
DOMAIN_NAME=your.domain
WORKGROUP_NAME=WORKGROUP
DOMAIN_ADMIN_USER=DOMAIN\Username
DOMAIN_ADMIN_PASSWORD=YourPassword

# WinRM Allowed IPs (comma-separated)
ALLOWED_IPS=192.168.1.100,192.168.1.101
```

## Available Scripts

### 1. AD_replication.ps1
- Monitors and diagnoses Active Directory replication status
- Provides detailed diagnostic information about replication failures
- Supports custom error thresholds via parameters

### 2. Disjoin_AD.ps1
- Safely removes a computer from the domain
- Joins the computer to a specified workgroup
- Handles credentials securely through environment variables

### 3. WinRM.ps1
- Configures Windows Remote Management (WinRM)
- Sets up firewall rules for specified IP addresses
- Configures TrustedHosts for secure remote management

### 4. RPC.ps1
- Configures necessary firewall rules for AD communication
- Sets up RPC (Remote Procedure Call) ports
- Enables required protocols for domain operations

## Usage Examples

### Setting up WinRM:
```powershell
.\WinRM.ps1
```

### Removing a computer from domain:
```powershell
.\Disjoin_AD.ps1
```

### Checking AD replication:
```powershell
.\AD_replication.ps1
```

## Security Note

- The `.env` file contains sensitive information and is excluded from git
- Never commit the `.env` file to version control
- Always use `.env.example` as a template for new deployments

## Troubleshooting

If you encounter errors:
1. Ensure all environment variables are properly set in `.env`
2. Verify you have appropriate administrative privileges
3. Check that required Windows features are installed
4. Verify network connectivity for WinRM and AD operations

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
