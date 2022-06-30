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

# Add a folder to $env:Path
function Prepend-EnvPath([string]$path) 
{ 
  # $env:PATH = $env:PATH + ";$path" 
  [Environment]::SetEnvironmentVariable("PATH", "$path;" + $Env:PATH, [EnvironmentVariableTarget]::Machine)
}

function Prepend-EnvPathIfExists([string]$path) 
{ 
  if (Test-Path $path) 
  { 
    Prepend-EnvPath $path 
  }
}

function Append-EnvPath([string]$path) 
{ 
  # $env:PATH = $env:PATH + ";$path"
  [Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";$path", [EnvironmentVariableTarget]::Machine)
}

function Append-EnvPathIfExists([string]$path)
{ 
  if (Test-Path $path) 
  { 
    Append-EnvPath $path
  }
}

function Is-Elevated() 
{
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  Return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}