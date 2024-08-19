import-module chocolatey-au

function global:au_GetLatest {
#   $WhatsNew = 'https://helpx.adobe.com/camera-raw/using/whats-new.html'
#   $Content = Invoke-WebRequest $WhatsNew -UseBasicParsing
#   $null = $content.RawContent.split("`n") -split '<p>' | 
#               Where-Object {$_ -match 'version ([0-9][0-9]\.[0-9.]+)'} |
#               Select Object -first 1

#   $version = $Matches[1]
#   $URLversion = $version.replace('.','_')

#   $Start = 'https://www.adobe.com/go/dng_converter_win'
   $request = [System.Net.HttpWebRequest]::Create('https://www.adobe.com/go/dng_converter_win')
   $response = $request.GetResponse()
   $url64 = $response.ResponseUri.AbsoluteUri
   $response.Close()

   $version = $url64 -replace '.*x64_([0-9_]+)\.exe','$1' -replace '_','.'

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
