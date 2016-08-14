$ErrorActionPreference = 'Stop'  # stop on all errors

$InstallPath = Join-Path $env:ProgramData 'Fusion-LDV'

$InstallArgs = @{
   packageName = 'fusion-ldv'
   installerType = 'exe'
   url = 'http://forsys.cfr.washington.edu/fusion/FUSION_Install.exe'
   Checksum = '978d71d68cf3da88e2440e60558b679efffb4826'
   ChecksumType = 'sha1'
   silentArgs = "/S /D=$InstallPath"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

# To support compressed LiDAR data, the LASzip.dll file from 
#   the lastools package needs to be found and copied.
$TargetPackage = 'lastools'
$TargetLib = "$env:ChocolateyInstall\lib\$TargetPackage"
$TargetUnzipLog = Get-ChildItem $TargetLib -Filter '*.zip.txt'
If ($TargetUnzipLog) {
   $TargetInstallLocation = Split-Path (Get-Content $TargetUnzipLog.FullName | Select-Object -First 1)
   $dll = Get-ChildItem $TargetInstallLocation -Filter 'laszip.dll' -Recurse | 
      Where-Object {$_.FullName -match '\\laszip\\'}
   Copy-Item $dll.fullname $InstallPath
} else {
   Write-Debug "Chocolatey package $TargetPackage install location not found!"
   Write-Debug 'LASzip is not available.  Compressed LiDAR data will be inaccessible.'
   Write-Debug 'Download from laszip.org and place LASzip.dll in Fusion-LDV directory.'
}


