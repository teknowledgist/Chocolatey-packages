$ErrorActionPreference = 'Stop'

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, ProductType, Caption, OperatingSystemSKU

Write-host "Detected:  $($osInfo.Caption)" -ForegroundColor Cyan

$osInfo.Version = [version] $osInfo.Version
if ($osInfo.Version -lt [version]'6.0') {
   Throw 'The Remote System Administration Toolkit (RSAT) requires Windows Vista or later.'
}
elseif ($osInfo.ProductType -ne 1) {
   Write-Warning 'The Remote System Administration Toolkit (RSAT) is built into Windows Server, so no need for an actual install.'
}
# See here for determining the edition of Windows via SKU:
#   https://superuser.com/questions/1328506/windows-edition-on-non-english-systems
# The list below are the valid SKUs for Windows editions that can have RSAT
elseif ((1,4,6,16,27,28,48,49,70,72,84,103,121,122,125,126,129,130,133,161,162) -notcontains ($osInfo.OperatingSystemSKU)) {
   Throw 'The Remote System Administration Toolkit (RSAT) can only install on Professional, Enterprise, or Education editions of Windows.'
}
else {
   $web = New-Object Net.WebClient
   if ($osInfo.Version.Major -eq 6) {
      switch ($osInfo.Version.Minor) {
         0 { # Vista
             If (Get-OSArchitectureWidth -eq 64) {
                Throw 'Vista x64 is not supported.'; return
             }
             $html = $web.DownloadString("https://www.microsoft.com/download/confirmation.aspx?id=21090") 
             $Checksum = '507c857b6a7cb15abaa36730b57d65487587ea62d7cf73f7b24542c1ef70038a' }
         1 { # Win7
             $html = $web.DownloadString("https://www.microsoft.com/download/confirmation.aspx?id=7887") 
             $Checksum = 'fcc36f0686f23bf57b0c719dfc86b06e8d2b501f93a08ed81704d15ab1726b41'
             $Checksum64 = '1d9f49878fff72d9954ec58cf10b72d8edc3d9126c10b1c4155b7912e2450f3c' }
         2 { # Win8
             $html = $web.DownloadString("https://www.microsoft.com/download/confirmation.aspx?id=28972") 
             $Checksum = '050aefe2568de7e9e28d75c6752a8287cbbb0f2a0f2be5dd0e0c75ba29aff941'
             $Checksum64 = '9799352c104d56a3bb7e5f931dadb4aa3361fce3d41be23699787a23347f207a' }
         3 { # Win8.1
             $html = $web.DownloadString("https://www.microsoft.com/download/confirmation.aspx?id=39296") 
             $Checksum = 'eb62cfabdc0c3231a1ba2d5310f4ff1daf6294b89b143cc10b255becb1da5b75'
             $Checksum64 = 'dea5540a59e018e04e088afb2aa326fb690d27a983fd3cbffefbfcfdde20a47d' }
      }
   } elseif ($osInfo.Version.Major -eq 10) { # Windows 10
      $pp = Get-PackageParameters
      switch ($pp.Server) {
         '2016' { $WS = '2016'
                  $Checksum = '6d46ef85cb63cf5c949706b7890bc1bb56a8c30506700262fe5ef4999b7380f3'
                  $Checksum64 = '4aeb716f301783e56739f9b0a361e2aa4f1e1d6b947b76c1d61af70b0ff0b4c7' }
         '1709' { $WS = '1709'
                  $Checksum = 'b62f131993908e24f093c8d630b84d49a829d9f7922dab17aa2f42867b096c43'
                  $Checksum64 = '72b34e1bef5c790081ffda24e18a5eb3cbe26944baee604aae0deddd8bfe6ebc' }
         default { $WS = '1803'
                  $Checksum = '968c20e6492b89fe72fe1cf496b90b7106492258a02d1333a6aa810be7cf5b49'
                  $Checksum64 = '3908b653c8bc5567684ab2779ee110dc2c0d56d2a33a329fe5460ecce55aaebe' }
      }
      $html = $web.DownloadString("https://www.microsoft.com/download/confirmation.aspx?id=45520")
      Write-Host "Installing tools for managing Windows Server $WS." -ForegroundColor Cyan
   }

   $urls = select-string '"https[^"]*msu"' -input $html -AllMatches |
               ForEach-Object {$_.matches} | 
               ForEach-Object {$_.value.trim('"')} |
               Select-Object -unique |
               Where-Object {$_ -match "WS_?$WS"}

   $url        = $urls | where-Object {$_ -match 'x86' }
   $url64      = $urls | where-Object {$_ -match 'x64' }

   $packageArgs = @{
     PackageName   = $env:ChocolateyPackageName
     FileType      = 'msu'
     Url           = $url
     Url64bit      = $url64
     Checksum      = $Checksum
     Checksum64    = $Checksum64
     ChecksumType  = 'sha256'
     SilentArgs    = "/quiet /norestart"
     ValidExitCodes= @(0,3010,-2146233087,2359302)
   }
   Install-ChocolateyPackage @packageArgs
}
