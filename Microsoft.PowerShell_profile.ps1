# Profile for the Microsoft.Powershell Shell.
# ===========

Push-Location (Split-Path -parent $profile)
"scripts","aliases" | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location