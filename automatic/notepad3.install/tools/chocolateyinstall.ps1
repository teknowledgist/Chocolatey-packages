$ErrorActionPreference = 'Stop'

$BitLevel = Get-ProcessorBits

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

# This package is automated, but the embedded downloads are sometimes .zip and sometimes .exe
$ZipFiles = Get-ChildItem $toolsDir -Filter '*.zip'
If ($ZipFiles) {
   $UnzipDir = Join-Path $env:TEMP "$env:ChocolateyPackageName_$env:ChocolateyPackageVersion"

   If ($ZipFiles.count -eq 2) {
      if ($BitLevel -eq '64') {
         $ZipFile = $ZipFiles | Where-Object {$_.Name -notmatch 'x86'} 
      } else {
         $ZipFile = $ZipFiles | Where-Object {$_.Name -match 'x86'}
   } else { $ZipFile = $ZipFiles }

   Get-ChocolateyUnzip -FileFullPath $ZipFile.FullName -Destination $UnzipDir
   }
} else {
   $UnzipDir = $toolsDir
}

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   fileType     = 'EXE' 
   softwareName = "$env:ChocolateyPackageName*"
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
}

$Installers = Get-ChildItem $UnzipDir -Filter '*.exe'

if ($installers.count -eq 2) {
   # clearly, .zip not included
   $Installer64 = $installers | Where-Object {$_.name -notmatch 'x86'} | Select-Object -ExpandProperty fullname
   $Installer32 = $installers | Where-Object {$_.name -match 'x86'} | Select-Object -ExpandProperty fullname
   $InstallArgs.add('File',$Installer32)
   $InstallArgs.add('File64',$Installer64)
} else {
   # if zipped, then there should be only one .exe
   if ($BitLevel -eq '64') {
      $Installer64 = $installers | Where-Object {$_.name -notmatch 'x86'} | Select-Object -ExpandProperty fullname
      $InstallArgs.add('File64',$Installer64)
   } else {
      $Installer32 = $installers | Select-Object -ExpandProperty fullname
      $InstallArgs.add('File',$Installer32)
   }
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($exe in $Installers) {
   remove-item $exe.fullname -Force
}
