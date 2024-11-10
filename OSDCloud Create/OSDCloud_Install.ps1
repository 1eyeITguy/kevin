#Requires -RunAsAdministrator
<#
.DESCRIPTION
Installs WinGet, Microsoft ADK and the Windows PE add-on for Windows 11, version 22H2, and MDT.  ALso installs the OSDCloud 
PowerShell module if not intalled. 
.LINK
https://www.osdcloud.com/osdcloud/setup
#>
[CmdletBinding()]
param()

# Define the download URLs
$adkUrl = "https://go.microsoft.com/fwlink/?linkid=2271337"
$addonUrl = "https://go.microsoft.com/fwlink/?linkid=2271338"

# Define the installation paths
$adkInstallerPath = "C:\temp\adksetup.exe"
$addonInstallerPath = "C:\temp\adkwinpesetup.exe"

# Create C:\temp directory if it doesn't exist
if (-not (Test-Path -Path "C:\temp" -PathType Container)) {
    New-Item -Path "C:\temp" -ItemType Directory | Out-Null
    Write-Host -ForegroundColor Green "[+] Created C:\Temp Directory"
}

# Download the installers using curl 
Invoke-RestMethod -Uri $adkUrl -OutFile $adkInstallerPath
Invoke-RestMethod -Uri $addonUrl -OutFile $addonInstallerPath

# Install ADK silently
Write-Host -ForegroundColor Yellow "[-] Installing Windows ADK..."
Start-Process -FilePath $adkInstallerPath -ArgumentList "/quiet" -Wait
Write-Host -ForegroundColor Green "[+] Windows ADK Installed"

# Install WinPE Addon silently
Write-Host -ForegroundColor Yellow "[-] Installing WinPE Add-On..."
Start-Process -FilePath $addonInstallerPath -ArgumentList "/quiet" -Wait
Write-Host -ForegroundColor Green "[+] WinPE Add-On installed"

# Clean up: Delete the downloaded installers
Remove-Item -Path $adkInstallerPath, $addonInstallerPath -Force | Out-Null

Write-Host -ForegroundColor Green "[+] Windows ADK and the WinPE Addon pack have been installed silently."

# Check if the OSD module is installed
if (-not (Get-Module -ListAvailable -Name OSD)) {
    Write-Host -ForegroundColor Yellow "[!] OSD module is not installed. Installing the latest version..."

    Write-Host -ForegroundColor Green "[+] Transport Layer Security (TLS) 1.2"
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    # Pre-Load some OSDCloud functions
    Invoke-Expression (Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/OSDeploy/OSD/master/cloud/modules/_anywhere.psm1')
    osdcloud-InstallPackageManagement
    osdcloud-TrustPSGallery

    # Install the OSD module from the PowerShell Gallery
    Install-Module -Name OSD -Force

    # Import the newly installed module
    Import-Module -Name OSD
    Write-Host -ForegroundColor Green "[+] OSD module has been installed and imported."
} else {
    Write-Host -ForegroundColor Green "[+] OSD module is already installed."
}
