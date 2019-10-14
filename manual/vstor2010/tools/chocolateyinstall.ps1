$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   url           = 'https://download.microsoft.com/download/C/A/8/CA86DFA0-81F3-4568-875A-7E7A598D4C1C/vstor_redist.exe'
   fileType      = 'EXE'
   Checksum      = '2B656781C884647A5368DADB0A4D63488413EA59A86D73E1802308D526B2BF84'
   checksumType  = 'sha256'
   softwareName  = 'Microsoft Visual Studio 2010 Tools for Office Runtime*'
   silentArgs    = '/quiet /norestart'
   validExitCodes= @(0, 3010)
}

$OfficeApps = 'excel.exe','Lync.exe','MSACCESS.EXE','MSPUB.EXE','OUTLOOK.EXE','powerpnt.exe','winword.exe'
$OfficeVersions = 12,14,15,16

$Found = $false
foreach ($app in $OfficeApps) {
   $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$App"
   if (Test-Path $RegPath) {
      $key = Get-ItemProperty -Path $RegPath -Name "Path"
      $ver = $key.path -replace '.*?(\d\d)\\$','$1'
      if ($OfficeVersions -contains $ver) {
         $Found = $true
         break
      }
   }
}

if (-not $Found) {
   Write-Warning "No required application of MS Office was found!"
   Write-Warning "The install will continue, but customizations written"
   Write-Warning "for this runtime will not work without MS Office."
}

Install-ChocolateyPackage @packageArgs 