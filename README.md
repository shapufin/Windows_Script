Name:check_app.ps1

Purpouse: Checking if App is installed on PC-s on specified OU Path

Variables:
- $oupath | This variable is where you specifie your AD OU where you want the script to check

- $appInstalledFile && $appNotInstalledFile | Those variables are for logs which might come handy if you want to link this generated file with another script, even though you can merge script together in this case they are seperated

- $directoryToCheck | This variable is where you specify the service of the app you want to check.