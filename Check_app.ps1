# Define variables

$ouPath = ""#Example OU=YOURORGANIZATION UNIT STARTING FROM THE DEEPEST LEVEL,DC=YOURDOMAIN_MAIL_NAME,DC=YOUR_DOMAIN_ENDING(.loca or .local etc)

$appInstalledFile = "YOUR DIRECTORY/file.txt" #Create a log file .txt
$appNotInstalledFile = "YOUR DIRECTORY/file.txt" # Create a log file .txt for PC which has not the app installed
$directoryToCheck = "DIRECTORY TO CHECK" #What will the script check for each PC

# Import Active Directory module
Import-Module ActiveDirectory

# Get the list of computers in the specified OU
$computers = Get-ADComputer -SearchBase $ouPath -Filter * | Select-Object -ExpandProperty Name

# Initialize arrays to hold the results
$appInstalledComputers = @()
$appNotInstalledComputers = @()

# Check if the application directory exists on each computer
foreach ($computer in $computers) {
    Write-Host "Checking $computer"

    try {
        # Check if the directory exists on the remote computer
        $directoryExists = Invoke-Command -ComputerName $computer -ScriptBlock {
            param ($directoryToCheck)
            Test-Path -Path $directoryToCheck
        } -ArgumentList $directoryToCheck

        if ($directoryExists) {
            Write-Host "$computer has the application installed."
            $appInstalledComputers += $computer
        } else {
            Write-Host "$computer does not have the application installed."
            $appNotInstalledComputers += $computer
        }
    } catch {
        Write-Host "Failed to check $computer. Error: $_"
        $appNotInstalledComputers += $computer
    }
}

# Sorting the computer names
$sortedAppInstalledComputers = $appInstalledComputers | Sort-Object
$sortedAppNotInstalledComputers = $appNotInstalledComputers | Sort-Object

# Write the results to text files
$sortedAppInstalledComputers | Out-File -FilePath $appInstalledFile
$sortedAppNotInstalledComputers | Out-File -FilePath $appNotInstalledFile

Write-Host "Check completed. Results written to $appInstalledFile and $appNotInstalledFile."
