$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   url           = 'https://download.microsoft.com/download/8/6/4/8641e164-7796-4b34-81c7-30d24a5bd533/vstor_redist.exe'
   fileType      = 'EXE'
   Checksum      = '9511042EABB4123827D1799154B9B2754C8509CA742D4E1AEA919084563F0B1E'
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