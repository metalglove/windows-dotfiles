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

function Dotfile-WinGet-Apps()
{
  winget install Git.Git
  Append-EnvPathIfExists "C:\Program Files\Git\bin\" 'User'

  winget install -e --id vim.vim -v 9.0.0009
  Append-EnvPathIfExists "C:\Program Files\Vim\vim90\" 'User'

  # TODO: test these installs..
  winget install -e --id RuneLite.RuneLite # launcher
  winget install -e --id NickeManarin.ScreenToGif
  winget install -e --id Valve.Steam
  winget install -e --id OpenJS.NodeJS
  winget install -e --id Discord.Discord
  winget install -e --id Docker.DockerDesktop
  winget install -e --id Kubernetes.minikube
  winget install -e --id Mirantis.Lens
  winget install -e --id Microsoft.VisualStudioCode
  # vscode preferences?
  winget install -e --id Microsoft.VisualStudio.2022.Community
  # vsstudio preferences?
  winget install -e --id Nvidia.GeForceExperience
  winget install -e --id acaudwell.Gource
  winget install -e --id Corsair.iCUE.4
  # icue profile?
  winget install -e --id REALiX.HWiNFO
  winget install -e --id WinSCP.WinSCP
  winget install -e --id Balena.Etcher
  winget install -e --id Stellarium.Stellarium
  winget install -e --id Kitware.CMake
  # cmake special configs?
  winget install -e --id SpeedCrunch.SpeedCrunch
  winget install -e --id AntibodySoftware.WizTree
  winget install -e --id Microsoft.PowerToys
  # powertoys fancyzones settings
  winget install -e --id RustemMussabekov.Raindrop
  winget install -e --id Peppy.Osu!
  # for osu download songs from NAS?
  winget install -e --id WhatsApp.WhatsApp
  winget install -e --id Spotify.Spotify
  winget install -e --id ElectronicArts.EADesktop
  # EA app or origin?
  winget install -e --id Google.Chrome
  winget install -e --id Mozilla.Firefox
  winget install -e --id Codeusa.BorderlessGaming
  winget install -e --id Apple.iTunes
  winget install -e --id RileyTestut.AltServer
  winget install -e --id EpicGames.EpicGamesLauncher
  winget install -e --id ChristianSchenk.MiKTeX
  winget install -e --id Nvidia.GeForceExperience
  winget install -e --id Nvidia.CUDA
  winget install -e --id OBSProject.OBSStudio
  winget install -e --id Postman.Postman
  winget install -e --id WinSCP.WinSCP
  winget install -e --id Python.Python.3
  winget install -e --id qBittorrent.qBittorrent
  winget install -e --id TeamSpeakSystems.TeamSpeakClient
  winget install -e --id Wacom.WacomTabletDriver
  winget install -e --id VideoLAN.VLC
  winget install -e --id Corel.WinZip
  winget install -e --id 9P4CLT2RJ1RS --accept-package-agreements
  # musicbee; still need to install last.fm scrobbling
  winget install -e --id NordVPN.NordVPN
  winget install -e --id Microsoft.Office
  winget install -e --id Microsoft.Teams 
  winget install -e --id 9WZDNCRFJ3TJ --accept-package-agreements
  # 9WZDNCRFJ3TJ netflix (app allows for 4k playback, which is not achievable in browsers)
  winget install -e --id Plex.Plex
  winget install -e --id ActivityWatch.ActivityWatch
  winget install -e --id JeffreyPfau.mGBA
  
  # NOTE: not for now..
  # winget install -e --id Plex.Plexamp 
  # winget install -e --id JetBrains.Toolbox 
  # winget install -e --id Anaconda.Anaconda3 
  # winget install -e --id Rainmeter.Rainmeter 
}

function Dotfiles-Post-Bootstrap-Install() 
{
  # Ensure-Elevation
  # TODO: ask user whether he is sure to execute this command
  # these install steps will likely require interaction

  # fix annoying ethernet adapter bug at startup
  Register-Ethernet-Adapter-Fix

  # map drives
  # NOTE: temporarily commented
  # Map-NetworkDrives
  
  # install applications
  Dotfile-WinGet-Apps
}

# # Ensure that the powershell is running as Administrator
# $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# $elevated = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
# if (!$elevated) 
# {
#   $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
#   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
#   $newProcess.Verb = "runas";
#   $process = [System.Diagnostics.Process]::Start($newProcess);
#   $process.WaitForExit()
#   # exit  
# }

Dotfiles-Post-Bootstrap-Install