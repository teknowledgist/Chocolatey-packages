import-module chocolatey-au

$Global:au_NoCheckUrl = $true

function global:au_GetLatest {
   $Repo = 'https://github.com/input-leap/input-leap'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'qt6\.exe'} | Select-Object -ExpandProperty DownloadURL

   return @{ 
            Version  = $version
            URL64    = $url64
         }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^- Version *:).*" = "`${1} $($Latest.Version)"
         "(^- URL *:).*"     = "`${1} $($Latest.URL64)"
         "(^- SHA256 *:).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Get-RemoteFiles -Purge -NoSuffix
}


update -ChecksumFor none
if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
