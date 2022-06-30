# Gets the physical network adapter and pipes it to restart
function Restart-NetAdapter() 
{
  Get-NetAdapter -Name * -Physical | Restart-NetAdapter
}
