import-module chocolatey-au

function global:au_GetLatest {
   $ReleasURL = 'https://www.tenable.com/downloads/nessus-agents'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

   $Release_page = Invoke-WebRequest -Uri $ReleasURL

   $null = $Release_page.links |
               Where-Object {$_.innertext -match 'Nessus Agents ([0-9.]+)'} | 
               Select-Object -first 1

   $version = $Matches[1]

   $metadata = $Release_page.content.split('{}') | ? {$_ -match $version -and $_ -match 'msi"'} | select -First 2

   $x64ID = ($metadata | ? {$_ -match 'x64'}) -replace '.*"id":([0-9]+),.*','$1'
   $x32ID = ($metadata | ? {$_ -match 'Win32'}) -replace '.*"id":([0-9]+),.*','$1'

   return @{ 
      Version = $version
      URL32 = "https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/$x32ID/download?i_agree_to_tenable_license_agreement=true"
      URL64 = "https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/$x64ID/download?i_agree_to_tenable_license_agreement=true"
   }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor all
