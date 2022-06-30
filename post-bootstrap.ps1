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
  if (!($?))
  {
    Write-Host "The RestartEthernetAdapterFix job already exists."
    Return
  }
  Write-Warning "The RestartEthernetAdapterFix job is succesfully added to the scheduler."
}

function Dotfiles-Post-Bootstrap-Install() 
{
  # Ensure-Elevation
  # TODO: ask user whether he is sure to execute this command
  # these install steps will likely require interaction

  # fix annoying ethernet adapter bug at startup
  Register-Ethernet-Adapter-Fix

  # map drives
  Map-NetworkDrives
  
  # install applications
}

# Ensure that the powershell is running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$elevated = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (!$elevated) 
{
  $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = $myInvocation.MyCommand.Definition;
  $newProcess.Verb = "runas";
  $process = [System.Diagnostics.Process]::Start($newProcess);
  # exit  
}

Dotfiles-Post-Bootstrap-Install