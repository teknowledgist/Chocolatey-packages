$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   url           = 'https://download.microsoft.com/download/5/d/2/5d24f8f8-efbb-4b63-aa33-3785e3104713/vstor_redist.exe'
   fileType      = 'EXE'
   Checksum      = 'cfe1a40bbe4a50022db2164abdb0154984e2cecb761a23cdc81cb5754f6e0a18'
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
