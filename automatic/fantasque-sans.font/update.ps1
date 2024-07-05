import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/belluzj/fantasque-sans'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match 'normal\.zip'} | Select-Object -first 1 -ExpandProperty DownloadURL

   return @{ Version = $version; URL32 = $url }
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
   Write-host "Downloading Fantasque-Sans-Mono $($Latest.Version) zip file."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
