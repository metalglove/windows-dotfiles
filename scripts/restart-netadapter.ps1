# Gets the physical network adapter and pipes it to restart
function Restart-NetworkAdapter() 
{
  Get-NetAdapter -Name * -Physical | Restart-NetAdapter
}
