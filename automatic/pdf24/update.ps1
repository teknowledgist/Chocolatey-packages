import-module au

$Release = 'https://en.pdf24.org/pdf-creator-changelog.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $text = $download_page.AllElements | 
      Where-Object {$_.tagname -eq 'h2' -and $_.innertext -match '^version'} |
      Select-Object -ExpandProperty innertext -First 1
      
   $version = $text.split()[-1]
   
   $url = "https://stx.pdf24.org/download/pdf24-creator-$version.msi"

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading PDF24 $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
