function Map-NetworkDrives() 
{
  # map network drives
  Map-NetworkDrive "Y" "\\nasali\FamilyShare"
  Map-NetworkDrive "Z" "\\nasali\AstroPhotography"
}

function Register-Ethernet-Adapter-Fix()
{
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
  $trigger = New-JobTrigger -AtStartup
  $jobPath = "${home}\jobs\fix-ethernet-adapter.ps1"
  Register-ScheduledJob -Name "RestartEthernetAdapterFix" -Trigger $trigger -FilePath $jobPath -ErrorAction SilentlyContinue
  if ($?)
  {
    Write-Warning "The RestartEthernetAdapterFix job is succesfully added to the scheduler."
    Return
  }
  Write-Output "The RestartEthernetAdapterFix job already exists."
}

function Install-Applications() 
{
  $profileDir = Split-Path -parent $profile
  Start-Process -FilePath 'powershell.exe' -ArgumentList "-ExecutionPolicy Bypass -File ${profileDir}\elevated-post-bootstrap-installs.ps1" -Verb 'RunAs' -Wait
  # NOTE: spotify has to be installed in a non elevated session.
  winget install -e --id Spotify.Spotify # auto start... and requires installation on user privelages not admin! exit code 23

}

function Dotfiles-Post-Bootstrap-Install() 
{
  # fix annoying ethernet adapter bug at startup
  Register-Ethernet-Adapter-Fix

  # map drives
  Map-NetworkDrives
  
  # install applications
  Install-Applications

  Write-Output "Dotfiles installation completed!"
}

if (Is-Elevated)
{
  Write-Output "This post bootstrap script requires a non-elevated execution."
  Write-Output "When all the applications will get installed, the script itself elevates to 'runas'."
  Exit
}

Dotfiles-Post-Bootstrap-Install