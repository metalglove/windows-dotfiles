$profileDir = Split-Path -parent $profile
$scriptsDir = Join-Path $profileDir "scripts"

# Ensure that the profile & scripts directory is created
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
New-Item $scriptsDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# Copy the powershell scripts to the profile
Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1" -Force
Copy-Item -Path ./scripts/** -Recurse -Destination $scriptsDir -Include ** -Force

# Copy config files to the user's home directory
Copy-Item -Path ./home/** -Recurse -Destination $home -Include ** -Force

# Copy windows terminal settings to correct location
Copy-Item -Path ./home/windows-terminal/windows-terminal-settings.json ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json -Force

Remove-Variable scriptsDir
Remove-Variable profileDir

Write-Host "Bootstrap complete!"