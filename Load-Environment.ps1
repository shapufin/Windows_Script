function Load-DotEnv {
    param(
        [string]$envPath = (Join-Path $PSScriptRoot ".env")
    )
    
    if (Test-Path $envPath) {
        $content = Get-Content $envPath

        foreach ($line in $content) {
            if ($line.Trim() -and !$line.StartsWith("#")) {
                $key, $value = $line.Split('=', 2)
                $key = $key.Trim()
                $value = $value.Trim()
                
                # Remove surrounding quotes if they exist
                if ($value.StartsWith('"') -and $value.EndsWith('"')) {
                    $value = $value.Substring(1, $value.Length - 2)
                }
                
                # Set environment variable
                Set-Variable -Name $key -Value $value -Scope Script
                [System.Environment]::SetEnvironmentVariable($key, $value, [System.EnvironmentVariableTarget]::Process)
            }
        }
    }
    else {
        Write-Warning "No .env file found at $envPath"
    }
}

# Export the function
Export-ModuleMember -Function Load-DotEnv
