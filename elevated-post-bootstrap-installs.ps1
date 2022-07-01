function Dotfile-WinGet-Apps()
{
  winget install Git.Git
  Append-EnvPathIfExists "C:\Program Files\Git\bin\" 'User'

  winget install -e --id vim.vim -v 9.0.0009
  Append-EnvPathIfExists "C:\Program Files\Vim\vim90\" 'User'

  # y = requires interactions
  # most y's are likely fixed by using elevation
  winget install -e --id RuneLite.RuneLite # launcher
  winget install -e --id NickeManarin.ScreenToGif
  winget install -e --id Valve.Steam # y
  winget install -e --id OpenJS.NodeJS # y
  winget install -e --id Discord.Discord # y
  winget install -e --id Docker.DockerDesktop # y
  winget install -e --id Kubernetes.minikube # y
  winget install -e --id Mirantis.Lens
  winget install -e --id Microsoft.VisualStudioCode
  # vscode preferences?
  winget install -e --id Nvidia.GeForceExperience # y
  winget install -e --id acaudwell.Gource # y
  winget install -e --id REALiX.HWiNFO # starts up the app automatically..
  winget install -e --id WinSCP.WinSCP
  winget install -e --id Balena.Etcher
  winget install -e --id Stellarium.Stellarium # y
  winget install -e --id Kitware.CMake # y
  # cmake special configs?
  winget install -e --id SpeedCrunch.SpeedCrunch # y
  winget install -e --id AntibodySoftware.WizTree # y 
  winget install -e --id RustemMussabekov.Raindrop
  winget install -e --id Peppy.Osu!
  # for osu download songs from NAS?
  winget install -e --id WhatsApp.WhatsApp
  winget install -e --id Spotify.Spotify # auto start...
  winget install -e --id ElectronicArts.EADesktop # y
  # EA app or origin?
  winget install -e --id Google.Chrome # y
  winget install -e --id Mozilla.Firefox # y
  winget install -e --id Codeusa.BorderlessGaming # y
  winget install -e --id Apple.iTunes # y
  winget install -e --id RileyTestut.AltServer # y
  winget install -e --id EpicGames.EpicGamesLauncher # y
  winget install -e --id ChristianSchenk.MiKTeX
  # miktex requires some configuration I think?
  winget install -e --id OBSProject.OBSStudio # y
  winget install -e --id Postman.Postman # y
  winget install -e --id Python.Python.3 # y
  winget install -e --id qBittorrent.qBittorrent # y
  winget install -e --id TeamSpeakSystems.TeamSpeakClient  # y
  winget install -e --id Wacom.WacomTabletDriver # y
  winget install -e --id VideoLAN.VLC # y
  winget install -e --id Corel.WinZip # y
  winget install -e --id NordVPN.NordVPN # y autostart
  winget install -e --id Microsoft.Office # y
  winget install -e --id Microsoft.Teams
  winget install -e --id Plex.Plex # y auto start
  winget install -e --id ActivityWatch.ActivityWatch
  # still needs to extension for chrome https://chrome.google.com/webstore/detail/activitywatch-web-watcher/nglaklhklhcoonedhgnpgddginnjdadi/related
  # or just login to chrome with user and sync extensions?
  winget install -e --id JeffreyPfau.mGBA # y
  # winget install -e --id Nvidia.CUDA # y lengthy install time
  
  # TODO: test these installs..
  # winget install -e --id Microsoft.VisualStudio.2022.Community # y failed! likely due to vsstudio already being installed on dev machine
  # vsstudio preferences?
  # winget install -e --id Corsair.iCUE.4 # failed
  # icue profile?
  # winget install -e --id Microsoft.PowerToys # y failed, but starts?
  # powertoys fancyzones settings
  # winget install -e --id 9P4CLT2RJ1RS --accept-package-agreements # failed no store account found?
  # musicbee; still need to install last.fm scrobbling
  # winget install -e --id 9WZDNCRFJ3TJ --accept-package-agreements # failed no store account
  # 9WZDNCRFJ3TJ netflix (app allows for 4k playback, which is not achievable in browsers)
  
  
  # NOTE: not for now..
  # winget install -e --id Plex.Plexamp 
  # winget install -e --id JetBrains.Toolbox 
  # winget install -e --id Anaconda.Anaconda3 
  # winget install -e --id Rainmeter.Rainmeter 
}

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

# Ensure that the powershell is running as Administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
{
  Write-Output "The shell is not elevated; exiting.."
  Exit  
}