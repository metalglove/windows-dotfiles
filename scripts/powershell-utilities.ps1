# Reload the Shell
function Reload-Powershell()
{
  $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = "-nologo";
  [System.Diagnostics.Process]::Start($newProcess);
  Exit
}

# Common Editing needs
function Edit-Hosts()
{ 
  Invoke-Expression "sudo $(if($env:EDITOR -ne $null) { $env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" 
}
function Edit-Profile() 
{ 
  Invoke-Expression "$(if($env:EDITOR -ne $null) { $env:EDITOR } else { 'notepad' }) $profile" 
}

# System Update
function System-Update() 
{
  Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
  Update-Module
  Update-Help -Force
}

# Empty the Recycle Bin on all drives
function Empty-RecycleBin 
{
  $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
  $RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}

# Create a new directory and enter it
function CreateAndSet-Directory([string]$Path) 
{ 
  New-Item $Path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $Path
}