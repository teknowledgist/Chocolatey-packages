import-module au

function global:au_GetLatest {
   $WhatsNew = 'https://helpx.adobe.com/camera-raw/using/whats-new.html'
   $Content = Invoke-WebRequest $WhatsNew -UseBasicParsing
   $null = $content.RawContent.split("`n") -split '<p>' | 
               Where-Object {$_ -match 'version ([0-9][0-9]\.[0-9.]+)'} |
               Select Object -first 1

   $version = $Matches[1]
   $URLversion = $version.replace('.','_')

   $url64 = "https://download.adobe.com/pub/adobe/dng/win/AdobeDNGConverter_x64_$URLversion.exe"

   return @{ 
            Version      = $version.ToString()
            URL64        = $url64
         }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

update -ChecksumFor 64
