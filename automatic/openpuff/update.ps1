import-module chocolatey-au

function global:au_GetLatest {
   $SiteURL = 'https://embeddedsw.net'
   $DownPage =  Invoke-WebRequest "$SiteURL/OpenPuff_download.html" -UseBasicParsing

   $stub = $DownPage.Links | ? {$_.href -like '*.zip'} | Select-Object -ExpandProperty href

   $URL = "$SiteURL$($stub.trim('.'))"

   $DownPage.allelements | ? {$_}

   $null = $downpage.RawContent.split('>') | where {$_ -match '^v([0-9.]+) '}
   $version = $matches[1]

   return @{ 
      Version = $version
      URL32   = $URL
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "(^- Version:).*" = "`${1} $($Latest.Version)"
            "(^- URL:).*"     = "`${1} $($Latest.URL32)"
            "(^- SHA256+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading OpenPuff $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
