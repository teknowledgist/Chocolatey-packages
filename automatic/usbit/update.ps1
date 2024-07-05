import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURI = 'https://www.alexpage.de/usb-image-tool/download/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $Link = $download_page.links | Where-Object {$_.href -match '\.zip$'} | Select-Object -first 1

   $url = $Link.href
   $version = $Link.innerText.split() | Where-Object {$_ -match '^[0-9.]+$'} | Select-Object -First 1

   return @{ 
            Version = "$version"
            URL32   = $url
         }
}


function global:au_SearchReplace {
   @{
      'tools\VERIFICATION.txt' = @{
         '(^Version\s+:).*'      = "`${1} $($Latest.Version)"
         '(^URL\s+:).*'          = "`${1} $($Latest.URL32)"
         '(^Checksum\s+:).*'     = "`${1} $($Latest.Checksum32)"
      }
   }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading USBit $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix

   set-alias 7z $Env:chocolateyInstall\tools\7z.exe 
   $filePath = Get-Item "$PSScriptRoot\tools\*.zip"
   7z x $filePath "-o$PSScriptRoot\tools" -aoa license.txt

   $LicenseTXT = Get-Content "$PSScriptRoot\tools\license.txt" -Raw
   "Copied from inside usbit.zip file download`r`n`r`nLICENSE`r`n`r`n" + $LicenseTXT | 
         Out-File "$PSScriptRoot\tools\LICENSE.txt" -Force 
}

update -ChecksumFor none
