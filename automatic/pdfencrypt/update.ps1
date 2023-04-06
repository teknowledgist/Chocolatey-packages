import-module au


function global:au_GetLatest {
   $Repo = 'https://github.com/ryangriggs/PDFEncrypt'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')

   return @{ 
            Version = $version
            URL32   = 'https://pdfencrypt.net/files/setup.exe'
           }
}

function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^SHA256\s+:).*"       = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading PDFEncrypt v$($Latest.Version) file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
