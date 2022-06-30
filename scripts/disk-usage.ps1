function Convert-ToDiskSize([int64]$bytes, [string]$precision='0' ) 
{
  foreach ($size in ("B","K","M","G","T")) 
  {
    if (($bytes -lt [int64]1000) -or ($size -eq "T")) 
    {
      $bytes = ($bytes).tostring("F0" + "$precision")
      Return "${bytes}${size}"
    }
    else 
    { 
      $bytes /= 1KB 
    }
  }
}

# Determine size of a file or total size of a directory
function Get-DiskUsage([string]$Path=(Get-Location).Path) 
{
  $length = [int64](Get-ChildItem .\ -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
  Convert-ToDiskSize $length 1
}