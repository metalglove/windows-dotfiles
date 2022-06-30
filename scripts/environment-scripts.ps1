# Reload the $env object from the registry
function Refresh-Environment()
{
  $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                'HKCU:\Environment'

  $locations | ForEach-Object 
  {
    $k = Get-Item $_
    $k.GetValueNames() | ForEach-Object 
    {
      $name  = $_
      $value = $k.GetValue($_)
      Set-Item -Path Env:\$name -Value $value
    }
  }

  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([string]$variable, [string]$value) 
{
  Set-ItemProperty "HKCU:\Environment" $variable $value
  Invoke-Expression "`$env:${variable} = `"$value`""
}

function Append-EnvPath(
  [Parameter(Mandatory=$true)][string]$Path, 
  [ValidateSet('Machine', 'User', 'Session')][string]$Container = 'Session') 
{
  if ($Container -ne 'Session') 
  {
    $containerMapping = @{
      Machine = [EnvironmentVariableTarget]::Machine
      User = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]

    $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
    if ($persistedPaths -notcontains $Path) 
    {
      $persistedPaths = $persistedPaths + $Path | Where-Object { $_ }
      [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
    }
  }

  $envPaths = $env:Path -split ';'
  if ($envPaths -notcontains $Path) 
  {
    $envPaths = $envPaths + $Path | Where-Object { $_ }
    $env:Path = $envPaths -join ';'
  }
}

function Remove-EnvPath(
  [Parameter(Mandatory=$true)][string]$Path, 
  [ValidateSet('Machine', 'User', 'Session')][string]$Container = 'Session') 
{
  if ($Container -ne 'Session') 
  {
    $containerMapping = @{
      Machine = [EnvironmentVariableTarget]::Machine
      User = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]

    $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
    if ($persistedPaths -contains $Path) 
    {
      $persistedPaths = $persistedPaths | Where-Object { $_ -and $_ -ne $Path }
      [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
    }
  }

  $envPaths = $env:Path -split ';'
  if ($envPaths -contains $Path) 
  {
    $envPaths = $envPaths | Where-Object { $_ -and $_ -ne $Path }
    $env:Path = $envPaths -join ';'
  }
}

function Get-EnvPath([Parameter(Mandatory=$true)][ValidateSet('Machine', 'User')][string]$Container) 
{
  $containerMapping = @{
    Machine = [EnvironmentVariableTarget]::Machine
    User = [EnvironmentVariableTarget]::User
  }
  $containerType = $containerMapping[$Container]
  [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';' | Where-Object { $_ }
}

function Append-EnvPathIfExists(
  [Parameter(Mandatory=$true)][string]$Path, 
  [ValidateSet('Machine', 'User', 'Session')][string]$Container = 'Session')
{ 
  if (Test-Path $Path) 
  { 
    Append-EnvPath $Path $Container
  }
}
