concat('powershell Set-ExecutionPolicy Bypass -Force ; powershell -Command \"Invoke-WebRequest \"\"https://github.com/docker/compose/releases/download/1.20.1/docker-compose-Windows-x86_64.exe\"\" -UseBasicParsing -OutFile C:\ARMProvisioningSkript.ps1; & C:\ARMProvisioningSkript.ps1 \"\"',parameters('dns'),'.westeurope.cloudapp.azure.com\"\"')]"



Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force ; 
    Install-Module DockerMsftProvider -Force ; 
    Install-Package Docker -ProviderName DockerMsftProvider -Force; 
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; 
    Invoke-WebRequest \"\"https://github.com/docker/compose/releases/download/1.20.1/docker-compose-Windows-x86_64.exe\"\" -UseBasicParsing -OutFile ${Env:ProgramFiles}\\docker\\docker-compose.exe; 
    $publicHostName = \"\"',parameters('dns'),'.westeurope.cloudapp.azure.com\"\"; 
    New-NetFirewallRule -LocalPort 8080 -Name WinRM-Https-In-Internet -DisplayName WinRM-Https-In-Internet -Protocol TCP -Direction Inbound -Action Allow -RemoteAddress Internet; 
    New-SelfSignedCertificate -DnsName $publicHostName -CertStoreLocation \"\"cert:\\LocalMachine\\My\"\"; 
    $cert = (Get-ChildItem -path cert:\\LocalMachine\\My | where { $_.Subject -eq \"\"CN=$publicHostName\"\" })[0]; 
    $winRmCommand = \"\"winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=\"\"\"\"$publicHostName\"\"\"\";
    CertificateThumbprint=\"\"\"\"$($cert.Thumbprint)\"\"\"\";Port=\"\"\"\"8080\"\"\"\"}\"\"; 
    cmd.exe /c $winRmCommand; 
    Restart-Computer -Force;\"





    "commandToExecute": "[concat('powershell Set-ExecutionPolicy Bypass -Force ; powershell -Command \" Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force ; Install-Module DockerMsftProvider -Force ; Install-Package Docker -ProviderName DockerMsftProvider -Force; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest \"\"https://github.com/docker/compose/releases/download/1.20.1/docker-compose-Windows-x86_64.exe\"\" -UseBasicParsing -OutFile $Env:ProgramFiles\\docker\\docker-compose.exe; $publicHostName = \"\"',parameters('dns'),'.westeurope.cloudapp.azure.com\"\"; New-NetFirewallRule -LocalPort 8080 -Name WinRM-Https-In-Internet -DisplayName WinRM-Https-In-Internet -Protocol TCP -Direction Inbound -Action Allow -RemoteAddress Internet; New-SelfSignedCertificate -DnsName $publicHostName -CertStoreLocation \"\"cert:\\LocalMachine\\My\"\"; $cert = (Get-ChildItem -path cert:\\LocalMachine\\My | where { $_.Subject -eq \"\"CN=$publicHostName\"\" })[0]; $winRmCommand = \"\"winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=\"\"\"\"$publicHostName\"\"\"\";CertificateThumbprint=\"\"\"\"$($cert.Thumbprint)\"\"\"\";Port=\"\"\"\"8080\"\"\"\"}\"\"; cmd.exe /c $winRmCommand; Restart-Computer -Force; ')]"