import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/JulietaUla/Montserrat'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   return @{ 
      Version = $Release.Tag.trim('v.')
      URL32   = $Release.ZipBallURL
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*" = "`${1} $($Latest.Version)"
            "(^URL\s+:).*"     = "`${1} $($Latest.URL32)"
            "(^SHA256\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Montserrat font $($Latest.Version) zip file"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
