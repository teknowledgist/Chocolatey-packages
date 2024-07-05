import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/henrypp/chrlauncher'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match '-bin\.zip'} | Select-Object -ExpandProperty DownloadURL
   $CheckFile = $Release.Assets | Where-Object {$_.FileName -match '\.sha256'} | Select-Object -ExpandProperty DownloadURL

   return @{ 
            Version   = $version
            URL32     = $url
            Checkfile = $CheckFile
           }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
         "^https.*sha256"        = "$($Latest.Checkfile)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading ChrLauncher v$($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
