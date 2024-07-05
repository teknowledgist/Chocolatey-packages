import-module chocolatey-au

function global:au_GetLatest {
   $DownloadURL = 'https://www.zhornsoftware.co.uk/stickies/download.html'
   $DownloadPage = Invoke-WebRequest -Uri $DownloadURL

   $File = $DownloadPage.links |
                Where-Object {$_.href -match '\.exe'} | 
                Select-Object -ExpandProperty href -first 1

   $URL32 = "https://www.zhornsoftware.co.uk/stickies/$File"

   $versionURL = 'https://www.zhornsoftware.co.uk/stickies/versions.html'
   $versionPage = Invoke-WebRequest -Uri $versionURL
   $VersionString = $versionPage.AllElements | 
                     Where-Object {$_.tagname -eq 'p' -and $_.outerhtml -match 'versionheading'} | 
                     Select-Object  -ExpandProperty InnerText -first 1
   $Version = $VersionString.split(' ')[0].trim('v')
   if ($Version -match '[a-z]') {
      $NumEquiv = ([byte][char]$matches[0])-96
      $Version = $Version -replace '[a-z]',".$NumEquiv"
   }

   return @{ 
         Version = $Version
         URL32   = $URL32
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*" = "`${1} $($Latest.Version)"
         "(^- URL\s+:).*"     = "`${1} $($Latest.URL32)"
         "(^- SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
   }
}
function global:au_BeforeUpdate() { 
   Write-host "Downloading Stickies $($Latest.Version) installation file."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
