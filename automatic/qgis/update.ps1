import-module chocolatey-au

function global:au_GetLatest {
   $Downloads = 'https://download.qgis.org/downloads/'
   
   $PageText = Invoke-WebRequest -Uri $Downloads
   
   $file = $PageText.links | ? {$_.innertext -match '^QGIS-.*-([0-9.]+)-.*\.msi'} | select -last 1 -exp href
   $NewVersion = $Matches[1]
   
   $url = $Downloads + $file

   $SumURL = $url -replace '\.msi$','.sha256sum'
   
   $SumFile = "$env:temp\QGIS$NewVersion-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   $News = 'https://www.qgis.org/download/'
   $PageText = Invoke-WebRequest -Uri $News -UseBasicParsing
   if ($PageText.content.split("`n") | Where-Object {$_ -cmatch 'long-term (repositories|builds) currently (offer|provide) (QGIS)? ([0-9.]*)'}) {
      $LTRRelease = $Matches[4]
   } else {
      $LTRRelease = $PageText.content.split("`n") | Where-Object {$_ -cmatch '^([0-9.]*)$'} | Select-Object -First 1
   }
   Write-Host "LTR version: $LTRRelease"

   return @{ 
      Version    = $NewVersion
      LTRVersion = $LTRRelease
      URL64      = $url
      Checksum64 = $Checksum64
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]LTRversion = )('.*')"     = "`$1'$($Latest.LTRversion)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -NoCheckUrl -ChecksumFor none