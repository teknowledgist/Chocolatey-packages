import-module au

function global:au_GetLatest {
   $URL = 'https://realityripple.com/Software/Applications/SecondFactor/'
   $Page = Invoke-WebRequest -Uri $URL -UseBasicParsing

   $link = $page.links | ? {$_.href -match '\.exe'}
   $URL32 = if ($link.href -like 'http*') { $link.href } else { "https:$($link.href)" }

   $Version = $link.title -replace '.*?([0-9.]+).*','$1'

   return @{ 
         Version  = $version
         URL32    = $URL32
   }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^- URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^- Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading SecondFactor $($Latest.Version) installer file."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
