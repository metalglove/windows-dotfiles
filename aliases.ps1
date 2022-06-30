# Basic commands
function which([string]$name) 
{ 
  Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition 
}
function touch([string]$file) 
{ 
  "" | Out-File $file -Encoding ASCII 
}

# Sudo
function sudo() 
{
  if ($args.Length -eq 1) 
  {
    Start-Process $args[0] -verb "runas"
  }
  if ($args.Length -gt 1) 
  {
    Start-Process $args[0] -ArgumentList $args[1..$args.Length] -verb "runas"
  }
}

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${function:desktop} = { 
  Set-Location ~\OneDrive\Desktop -ErrorAction SilentlyContinue
  if (!($?))
  {
    Set-Location ~\OneDrive\Bureaublad 
  }
}
${function:docs} = { 
  Set-Location ~\OneDrive\Documents -ErrorAction SilentlyContinue
  if (!($?))
  {
    Set-Location ~\OneDrive\Documenten 
  }
}
${function:downloads} = { Set-Location ~\Downloads }

# Missing Bash aliases
Set-Alias time Measure-Command

# Correct PowerShell Aliases if tools are available (aliases win if set)
# WGet: Use `wget.exe` if available
if (Get-Command wget.exe -ErrorAction SilentlyContinue | Test-Path) 
{
  rm alias:wget -ErrorAction SilentlyContinue
}

$gitls = "C:\Program Files\Git\usr\bin\ls.exe"
# Directory Listing: Use `ls.exe` if available
if (Get-Command $gitls -ErrorAction SilentlyContinue | Test-Path) 
{
  rm alias:ls -ErrorAction SilentlyContinue
  # Set `ls` to call `ls.exe` and always use --color
  ${function:ls} = { & $gitls --color @args }
  # List all files in long format
  ${function:l} = { ls -lF @args }
  # List all files in long format, including hidden files
  ${function:la} = { ls -laF @args }
} 
else 
{
  # List all files, including hidden files
  ${function:la} = { ls -Force @args }
}

# List only directories
${function:lsd} = { Get-ChildItem -Directory -Force @args }

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) 
{
  rm alias:curl -ErrorAction SilentlyContinue
  # Set `ls` to call `ls.exe` and always use --color
  ${function:curl} = { curl.exe @args }
  # Gzip-enabled `curl`
  ${function:gurl} = { curl --compressed @args }
} 
else 
{
  # Gzip-enabled `curl`
  ${function:gurl} = { curl -TransferEncoding GZip }
}

# Create a new directory and enter it
Set-Alias mkdir CreateAndSet-Directory

# Determine size of a file or total size of a directory
Set-Alias fs Get-DiskUsage

# Empty the Recycle Bin on all drives
Set-Alias emptytrash Empty-RecycleBin

# Reload the shell
Set-Alias reload Reload-Powershell

# Update installed Ruby Gems, NPM, and their installed packages.
Set-Alias update System-Update
