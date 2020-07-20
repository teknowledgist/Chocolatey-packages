$ErrorActionPreference = 'Stop'  # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName
$BitLevel = Get-ProcessorBits

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $fileLocation
   silentArgs     = "/S"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
New-Item "$fileLocation.ignore" -Type file -Force | Out-Null

# To support compressed LiDAR data, the LASzip.dll file from 
#   the lastools package needs to be found and copied.
$TargetPackage = 'lastools'
$TargetLib = "$env:ChocolateyInstall\lib\$TargetPackage"
$TargetUnzipLog = Get-ChildItem $TargetLib -Filter '*.zip.txt'
$TargetDLL = 'laszip.dll'

If (Get-ProcessorBits -eq 64) {
   $TargetDLL = 'laszip64.dll'
   $VarAttribs = @{
         VariableName  = 'FUSION64'
         VariableValue = 'TRUE'
         VariableType  = 'Machine'
   }
   Install-ChocolateyEnvironmentVariable @VarAttribs
}
If ($TargetUnzipLog) {
   $TargetInstallLocation = Split-Path (Get-Content $TargetUnzipLog.FullName | Select-Object -First 1)
   $dll = Get-ChildItem $TargetInstallLocation -Filter $TargetDLL -Recurse | 
                  Where-Object {$_.FullName -match '\\laszip\\'}

   # Find where Fusion-LDV installed itself (no registry entry!)
   $StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu'
   $SMlink = Get-ChildItem $StartMenu -Filter 'Fusion.lnk' -Recurse
   if ($SMlink) {
      $Destination = Split-Path ((new-object -com wscript.shell).createShortcut($SMlink.FullName)).targetPath
   } elseif (Test-Path "${env:ProgramFiles(x86)}\FUSION") {
      $Destination = "${env:ProgramFiles(x86)}\FUSION"
   } 
   if ($Destination) {
      Copy-Item $dll.fullname $Destination
   } else {
      Write-Warning "$env:ChocolateyPackageName install location not found!"
      Write-Warning 'Compressed LiDAR data will be inaccessible.'
      Write-Warning 'Download from laszip.org and place LASzip.dll in Fusion-LDV directory.'
   }
} else {
   Write-Warning "Chocolatey package $TargetPackage install location not found!"
   Write-Warning 'LASzip is not available.  Compressed LiDAR data will be inaccessible.'
   Write-Warning 'Download from laszip.org and place LASzip.dll in Fusion-LDV directory.'
}


