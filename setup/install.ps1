# GitHub repository details
$account = "metalglove"
$repo = "windows-dotfiles"
$branch = "master"

$dotfilesTempDir = Join-Path $env:TEMP "dotfiles"
if (![System.IO.Directory]::Exists($dotfilesTempDir)) 
{
    [System.IO.Directory]::CreateDirectory($dotfilesTempDir)
}
$sourceFile = Join-Path $dotfilesTempDir "dotfiles.zip"
$dotfilesInstallDir = Join-Path $dotfilesTempDir "$repo-$branch"

function Download-File([string]$Url, [string]$File) 
{
    Write-Host "Downloading $Url to $File"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $Url -OutFile $File
}

function Unzip-File([string]$File, [string]$Destination = (Get-Location).Path)
{
    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    # NET Framework 4.8 is preinstalled in Windows 11.
    # https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/versions-and-dependencies#net-framework-48
    try 
    {
        [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
    }
    catch 
    {
        Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
    }
}

Download-File "https://github.com/$account/$repo/archive/$branch.zip" $sourceFile
if ([System.IO.Directory]::Exists($dotfilesInstallDir)) 
{
    [System.IO.Directory]::Delete($dotfilesInstallDir, $true)
}
Unzip-File $sourceFile $dotfilesTempDir

Push-Location $dotfilesInstallDir
Set-ExecutionPolicy -Scope CurrentUser Unrestricted -Force
& .\bootstrap.ps1
Pop-Location

$newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
$newProcess.Arguments = "-nologo";
[System.Diagnostics.Process]::Start($newProcess);
Exit