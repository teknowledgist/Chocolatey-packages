import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/deadlydog/PathLengthChecker'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match '\.zip'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
            Version = $version
            URL32   = $URL
           }
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
   Write-host "Downloading PathLengthChecker $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
