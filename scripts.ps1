# These scripts will be loaded for all PowerShell instances
Push-Location (Join-Path (Split-Path -parent $profile) "scripts")
Get-ChildItem -Path *.ps1 | Get-Item | ForEach-Object { Invoke-Expression ". $_" }
Pop-Location
