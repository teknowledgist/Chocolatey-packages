$ErrorActionPreference = 'Stop'

$1809Build = 17763

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, ProductType, Caption, OperatingSystemSKU, BuildNumber

Write-host "Detected:  $($osInfo.Caption)" -ForegroundColor Cyan

$osInfo.Version = [version]$osInfo.Version
if ($osInfo.Version -lt [version]'6.0') {
   Throw 'The Remote System Administration Toolkit (RSAT) requires Windows Vista or later.'
}
# OperatingSystemSKU = 175 Windows 10 Enterprise multi-session, see also:
#     https://docs.microsoft.com/en-us/azure/virtual-desktop/configure-automatic-updates#create-a-query-based-collection
elseif ($osInfo.ProductType -ne 1 -and $osInfo.OperatingSystemSKU -ne 175) {
   Write-Warning 'The Remote System Administration Toolkit (RSAT) is built into Windows Server, so no need for an actual install.'
   Return
}
# See here for determining the edition of Windows via SKU:
#   https://superuser.com/questions/1328506/windows-edition-on-non-english-systems
# The list below are the valid SKUs for Windows editions that can have RSAT
elseif ((1,4,6,16,27,28,48,49,70,72,84,103,121,122,125,126,129,130,133,161,162,175) -notcontains ($osInfo.OperatingSystemSKU)) {
   Throw 'The Remote System Administration Toolkit (RSAT) can only install on Professional, Enterprise, or Education editions of Windows.'
}

$pp = Get-PackageParameters

$web = New-Object Net.WebClient
if ($osInfo.Version.Major -eq 6) {
   switch ($osInfo.Version.Minor) {
      0 { # Vista
            Throw "$($osInfo.Caption) is not supported."}
      1 { # Win7
            Throw "$($osInfo.Caption) is not supported."}
      2 { # Win8
            $html = $web.DownloadString('https://www.microsoft.com/download/confirmation.aspx?id=28972') 
            $Checksum = '050aefe2568de7e9e28d75c6752a8287cbbb0f2a0f2be5dd0e0c75ba29aff941'
            $Checksum64 = '9799352c104d56a3bb7e5f931dadb4aa3361fce3d41be23699787a23347f207a' }
      3 { # Win8.1
            $html = $web.DownloadString('https://www.microsoft.com/download/confirmation.aspx?id=39296') 
            $Checksum = 'eb62cfabdc0c3231a1ba2d5310f4ff1daf6294b89b143cc10b255becb1da5b75'
            $Checksum64 = 'dea5540a59e018e04e088afb2aa326fb690d27a983fd3cbffefbfcfdde20a47d' }
   }
} elseif ($osInfo.Version.Major -eq 10) { # Windows 10
   if (($osInfo.BuildNumber -lt $1809Build) -or ($pp.Win10)) {
      # Documentation indicates that these work for all pre-1809 Win10 releases
      $Checksum = '99ed8359fcd5927cb4dd1ff83ce909bda87c12c4092cf81b121853e5ca8dd7ec'
      $Checksum64 = 'c01b90a7b79a4d5ac4ad89b404368e9053657d8e86bcbd60ee69fa1a6bc402c7'

      $html = $web.DownloadString('https://www.microsoft.com/en-us/download/details.aspx?id=45520')
      if ($pp.Win10) {
         Write-Host 'You have requested to install the last Win10 download regardless of Windows version.' -ForegroundColor Cyan
      } else {
         Write-Host "Installing tools for managing Windows prior to 1809 release." -ForegroundColor Cyan
      }
   }
}


If (($osInfo.Version.Major -ne 10) -or ($osInfo.BuildNumber -lt $1809Build) -or ($pp.Win10)) {
   $urls = select-string '"https[^"]*msu"' -input $html -AllMatches |
   ForEach-Object {$_.matches} | 
   ForEach-Object {$_.value.trim('"')} |
   Select-Object -unique

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
      SilentArgs    = '/quiet /norestart'
      ValidExitCodes= @(0,3010,-2146233087,2359302)
   }
   Install-ChocolateyPackage @packageArgs

} else {
   # Based on https://github.com/imabdk/Powershell/blob/master/Install-RSATv1809v1903v1909v2004v20H2.ps1
   $WSUSKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
   if (Test-Path $WSUSKey) {
      Write-Verbose 'Saving UseWUServer value and temporarily disabling WSUS.'
      $Save = (Get-ItemProperty -Path $WSUSKey -Name 'UseWUServer' -ErrorAction SilentlyContinue).UseWUServer
      Set-ItemProperty -Path $WSUSKey -Name 'UseWUServer' -Value 0
      Restart-Service wuauserv
   }

   $WhereArray = @()
   if ($pp.AD) {$WhereArray += '($_.Name -like "Rsat.ActiveDirectory*")'}
   if ($pp.GP) {$WhereArray += '($_.Name -like "Rsat.GroupPolicy*")'}
   if ($pp.SM) {$WhereArray += '($_.Name -like "Rsat.ServerManager*")'}
   if ($pp.CS) {$WhereArray += '($_.Name -like "Rsat.CertificateServices*")'}
   if ($pp.RD) {$WhereArray += '($_.Name -like "Rsat.RemoteDesktop*")'}
   if ($pp.FS) {$WhereArray += '($_.Name -like "Rsat.FileServices*")'}
   if ($pp.DNS) {$WhereArray += '($_.Name -like "Rsat.DNS*")'}
   if ($pp.DHCP) {$WhereArray += '($_.Name -like "Rsat.DHCP*")'}
   if ($pp.WSUS) {$WhereArray += '($_.Name -like "Rsat.WSUS*")'}
   if ($pp.BL) {$WhereArray += '($_.Name -like "Rsat.BitLocker*")'} 

   if ($WhereArray.count -eq 0) {
      $WhereArray += '$_.Name -like "Rsat*"'
   }
   $WhereString = '$_.State -eq "NotPresent" -AND (' + ($WhereArray -join ' -OR ') + ')'

   $Tools = Get-WindowsCapability -Online | Where-Object $([scriptblock]::Create($WhereString))
   foreach ($Item in $Tools) {
      try {
         Write-Host "`nAdding $($Item.Name) to Windows"
         $DISMobject = Add-WindowsCapability -Online -Name $Item.Name
         if ($DISMobject.RestartNeeded) {
            Write-Warning 'A reboot is required.'
         }
      }
      catch { Write-Warning -Message $_.Exception.Message; break }
   }
   Write-Host "`n"
   Write-Verbose "Windows Feature install log is at $($DISMobject.LogPath)"

   if (Test-Path $WSUSKey) {
      If ($Save -ne $null) {
         Write-Verbose 'Restoring UseWUServer value and re-enabling WSUS.'
         Set-ItemProperty -Path $WSUSKey -Name 'UseWUServer' -Value $Save
      } else {
         Remove-ItemProperty -Path $WSUSKey -Name 'UseWUServer' -Force
      }
      Restart-Service wuauserv
   }
}
