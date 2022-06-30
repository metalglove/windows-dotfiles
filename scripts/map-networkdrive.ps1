function Map-NetworkDrive([string]$DriveLetter, [string]$NetworkPath)
{
  # check whether the drive is already mapped
  $pathExists = Test-Path -Path "${DriveLetter}:\"
  if ($pathExists) 
  {
    Write-host "Driveletter ${DriveLetter}:\ already exists, skipping mapping..."
    Return
  }

  # ask credentials for the login to the network drive
  $cred = Get-Credential

  # map network drive
  New-PSDrive -Name $DriveLetter -Root $NetworkPath -Persist -PSProvider "FileSystem" -Credential $cred -Scope Global

  $pathExists = Test-Path -Path "${DriveLetter}:\"
  if ($pathExists) 
  {
    Write-host "Driveletter ${DriveLetter}:\ is succesfully mapped to ${NetworkPath}!"
    Return
  }
  Write-Warning "Driveletter ${DriveLetter}:\ has failed to be mapped to ${NetworkPath}!"
}
