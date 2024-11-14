import-module chocolatey-au

function global:au_GetLatest {
   $news = 'https://sourceforge.net/p/asymptote/news/'
   $NewsPage = Invoke-WebRequest -Uri $News -UseBasicParsing

   $LatestText = $NewsPage.links |
                Where-Object {$_.outerhtml -match 'released'} | 
                Select-Object -ExpandProperty outerhtml -first 1
   $version = $LatestText.split() | Where-Object {$_ -match '^[0-9.]+$'}

   $URL64 = "https://sourceforge.net/projects/asymptote/files/$version/asymptote-$($version)-setup.exe"

   return @{ 
         Version = $version
         URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^- x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^- x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading Asymptote $($Latest.Version) installer files."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
