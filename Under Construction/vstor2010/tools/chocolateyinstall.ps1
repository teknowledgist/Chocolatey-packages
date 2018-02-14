$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   url           = 'https://download.microsoft.com/download/7/A/F/7AFA5695-2B52-44AA-9A2D-FC431C231EDC/vstor_redist.exe'
   fileType      = 'EXE'
   Checksum      = 'C34E03C24EEA01F90D5796490F38822884DE7A7DA34232526E728FFC8073C2A1'
   checksumType  = 'sha256'
   softwareName  = 'Microsoft Visual Studio 2010 Tools for Office Runtime*'
   silentArgs    = '/quiet /norestart'
   validExitCodes= @(0, 3010)
}

$OfficeApps = 'winword.exe','excel.exe','outlook.exe','powerpnt.exe','vision.exe','infopath.exe','winproj.exe'
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