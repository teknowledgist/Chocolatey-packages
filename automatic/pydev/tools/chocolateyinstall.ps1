$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path
$FolderOfPackage = Split-Path -Parent $toolsDir

# First find where eclipse is installed
$HostPackage = 'eclipse'
$HostPackageLocation = "$env:ChocolateyInstall\lib\$HostPackage"
$HostUnzipLog = Get-ChildItem $HostPackageLocation -Filter "$HostPackage.*.txt" |
                  sort creationtime | select -last 1
If ($HostUnzipLog) {
   $HostInstallLocation = Get-Content $HostUnzipLog.FullName | Select-Object -First 1
} else {
   throw "Chocolatey package $HostPackage install location not found!"
}

$dropins = join-path $hostinstalllocation 'eclipse\dropins'

$installArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = $dropins
}

Get-ChocolateyUnzip @installArgs

$logPath = Join-Path $FolderOfPackage "PyDevInstallLocation.txt"
Set-Content $logPath $dropins -Encoding UTF8 -Force
