import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/zufuliu/notepad4'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.').replace('r','.')
   $URL32 = $Release.Assets | Where-Object {$_.FileName -match 'Notepad4_en_Win32.*\.zip'} | Select-Object -Last 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'Notepad4_en_x64.*\.zip'} | Select-Object -Last 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL32   = $URL32
      URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
            "^(- Version\s+:).*"    = "`${1} $($Latest.Version)"
            "^(- URL\s+:).*"        = "`${1} $($Latest.URL32)"
            "^(- Checksum\s+:).*"   = "`${1} $($Latest.Checksum32)"
            "^(- URL64\s+:).*"      = "`${1} $($Latest.URL64)"
            "^(- Checksum64\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading Notepad4 $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
