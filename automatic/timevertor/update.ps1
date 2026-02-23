import-module chocolatey-au


function global:au_GetLatest {
   $Repo = 'https://github.com/henrypp/timevertor'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL = $Release.Assets | Where-Object {$_.FileName -match 'bin\.zip'} | Select-Object -First 1 -ExpandProperty DownloadURL
   $CheckFile = $Release.Assets | Where-Object {$_.FileName -match '\.sha256'} | Select-Object -First 1 -ExpandProperty DownloadURL

   $TempSum = "$env:temp\timevertor.SHA256.txt"
   Invoke-WebRequest $CheckFile -OutFile $TempSum
   $Checksum32 = (Get-Content $TempSum | Where-Object {$_ -like '*bin.zip'}).split()[0]

   return @{ 
            Version    = $version
            URL32      = $url
            Checksum32 = $Checksum32
            Checkfile  = $CheckFile
           }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^- URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^- SHA256\s+:).*"       = "`${1} $($Latest.Checksum32)"
         "(^\d\. )https.*256$"   = "`${1}$($Latest.Checkfile)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading TimeVertor v$($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
