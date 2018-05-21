
$packageName = 'RSAT'
$osInfo = Get-WmiObject Win32_OperatingSystem | SELECT Version, ProductType, Caption
$osInfo.Version = [version] $osInfo.Version

$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

if ($osInfo.Version -lt [version]'6.0') {
    Throw 'The Remote System Administration Tool (RSAT) requires Windows Vista or later.'
    return
}
elseif ($osInfo.ProductType -ne 1) {
    Write-Warning 'The RSAT is built into Windows server OSes, making this effectively a stub package'
}
else {
  $Lang=[System.Globalization.Cultureinfo]::CurrentCulture
  $Lang=$Lang.Name.ToLower()
  $web = New-Object Net.WebClient
    if ($osInfo.Version.Major -eq 6) {
      if ($osInfo.Version.Minor -eq 0) { #Windows Vista
        Write-host 'Vista Detected' -foregroundcolor Cyan
        $web = $web.DownloadString("https://www.microsoft.com/$Lang/download/confirmation.aspx?id=21090")
      } elseif ($osInfo.Version.Minor -eq 1) { #Windows 7
          Write-host 'Windows 7 Detected' -foregroundcolor Cyan
          $web = $web.DownloadString("https://www.microsoft.com/$Lang/download/confirmation.aspx?id=7887")
      } elseif ($osInfo.Version.Minor -eq 2) { #Windows 8
          Write-host 'Windows 8 Detected' -foregroundcolor Cyan
          $web = $web.DownloadString("https://www.microsoft.com/$Lang/download/confirmation.aspx?id=28972")
      } elseif ($osInfo.Version.Minor -eq 3) { #Windows 8.1
          Write-host 'Windows 8.1 Detected' -foregroundcolor Cyan
          $web = $web.DownloadString("https://www.microsoft.com/$Lang/download/confirmation.aspx?id=39296")
      }
    } elseif ($osInfo.Version.Major -eq 10) { #Windows 10
        if ($osInfo.Version.Minor -eq 0) {
          Write-host 'Windows 10 Detected' -foregroundcolor Cyan
          $web = $web.DownloadString("https://www.microsoft.com/$Lang/download/confirmation.aspx?id=45520")
        }
    }
  if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64"){
    Write-host 'x64 Detected' -foregroundcolor yellow
    if ($osInfo.Version.Major -eq 6 -And $osInfo.Version.Minor -eq 0) {write-host 'Vista x64 is not supported, exiting';break}
  }else{
    Write-host 'x86 Detected' -forgroundcolor yellow
  }

  $urls = select-string '"https[^"]*msu"' -input $web -AllMatches |% {$_.matches} | % {$_.value.trim('"')} |select -unique

  $url        = $urls | where-Object {$_ -match 'x86' }
  $url64      = $urls | where-Object {$_ -match 'x64' }

  $packageArgs = @{
    packageName   = $packageName
    fileType      = 'msu'
    url           = $url
    url64bit      = $url64
    silentArgs    = "/quiet /norestart"
    validExitCodes= @(0,3010,-2146233087,2359302)
  }
  Install-ChocolateyPackage @packageArgs
}
