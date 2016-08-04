$ErrorActionPreference = 'Stop'  # stop on all errors

$ZipArgs = @{
   PackageName = 'lastools'
   Url = 'http://www.cs.unc.edu/~isenburg/lastools/download/LAStools.zip'
   UnzipLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
}

Install-ChocolateyZipPackage @ZipArgs



  @(
  'AccessEnum',
  'ADExplorer',
  'AdInsight',
  'Autoruns',
  'Bginfo',
  'Cachset',
  'Dbgview',
  'Desktops',
  'disk2vhd',
  'DiskView',
  'LoadOrd',
  'pagedfrg',
  'portmon',
  'procexp',
  'Procmon',
  'RAMMap',
  'RootkitRevealer',
  'Tcpview',
  'vmmap',
  'ZoomIt'
  ) | % {
    New-Item "$installDir\$_.exe.gui" -Type file -Force | Out-Null
  }