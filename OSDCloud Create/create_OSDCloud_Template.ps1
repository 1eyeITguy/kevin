Import-Module OSD -Force

# Define Veriables
$WorkspacePath = "C:\OSDCloud_merit"
$UnattendPath = "C:\Merit\SupportFiles\Unattend.xml"
$DestinationPath = "$WorkspacePath\Media"

# Check if the workspace directory exists, if not, create it
if (!(Test-Path -Path $WorkspacePath)) {
    New-Item -Path $WorkspacePath -ItemType Directory -Force
}

# Create OSDCloud Workspace
New-OSDCloudTemplate
New-OSDCloudWorkspace -WorkspacePath $WorkspacePath

Copy-Item -Path $UnattendPath -Destination $DestinationPath -Force

# Customize the WinPE image
Edit-OSDCloudWinPE -WorkspacePath $WorkspacePath `
    -CloudDriver * `
    -WebPSScript https://gist.githubusercontent.com/1eyeITguy/162ce4499b8f06df8dc3b8abdede1245/raw/1786cf495010d26bc93816d01ae6b0713760fd8c/OSDCloud_Config.ps1 `
    -Wallpaper "C:\Merit\logo\merit_wallpaper.jpg"