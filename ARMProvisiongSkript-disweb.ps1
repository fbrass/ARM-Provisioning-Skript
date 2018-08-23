Param(
    $dns
    )

    Install-WindowsFeature Web-ASP; `
    Install-WindowsFeature Web-CGI; `
    Install-WindowsFeature Web-ISAPI-Ext; `
    Install-WindowsFeature Web-ISAPI-Filter; `
    Install-WindowsFeature Web-Includes; `
    Install-WindowsFeature Web-HTTP-Errors; `
    Install-WindowsFeature Web-Common-HTTP; `
    Install-WindowsFeature Web-Performance; `
    Install-WindowsFeature WAS; `
    Install-WindowsFeature NET-Framework-45-ASPNET ; `
    Install-WindowsFeature NET-WCF-HTTP-Activation45; `
    Import-module IISAdministration;





Write-Output "Install IIS"
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging
Enable-WindowsOptionalFeature -Online -FeatureName IIS-LoggingLibraries
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpTracing
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Metabase
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic




    
Write-Output "Starting ARMProvisioningSkript Powershell skript";
Write-Output "input $dns";
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force ; 
Write-Output "Packageprovider Installation finished";

Install-Module DockerMsftProvider -Force ; 
Install-Package Docker -ProviderName DockerMsftProvider -Force; 
Write-Output "Docker Installation finished";

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; 
Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.20.1/docker-compose-Windows-x86_64.exe" -UseBasicParsing -OutFile ${Env:ProgramFiles}\\docker\\docker-compose.exe; 
Write-Output "Docker compose installation finished";


New-NetFirewallRule -LocalPort 5986 -Name WinRM-Https-In-Internet -DisplayName WinRM-Https-In-Internet -Protocol TCP -Direction Inbound -Action Allow -RemoteAddress Internet; 
New-NetFirewallRule -LocalPort 445 -Name SMB-For-TFS-TCP -DisplayName SMB-For-TFS-TCP -Protocol TCP -Direction Inbound -Action Allow -RemoteAddress Internet; 
New-NetFirewallRule -LocalPort 445 -Name SMB-For-TFS-UDP -DisplayName SMB-For-TFS-UDP -Protocol UDP -Direction Inbound -Action Allow -RemoteAddress Internet; 
write-Output "Firewall configured"

$publicHostName = "$dns.westeurope.cloudapp.azure.com"; 
Write-Output "publicHostName: $publicHostName";

New-SelfSignedCertificate -DnsName $publicHostName -CertStoreLocation "cert:\\LocalMachine\\My"; 
Write-Output "New-SelfSignedCertificate done";

$cert = (Get-ChildItem -path cert:\\LocalMachine\\My | where { $_.Subject -eq "CN=$publicHostName" })[0]; 
Write-Output "cert: $cert";

$winRmCommand = 'winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="' + $publicHostName + '";CertificateThumbprint="' + $cert.Thumbprint + '";Port="5986"}';
Write-Output "winRmCommand $winRmCommand";


cmd.exe /c $winRmCommand; 
Write-Output "winrmcommand ausgeführt"





