import-module chocolatey-au

$FilesPage = 'https://sourceforge.net/projects/brlcad/files/'

function global:au_GetLatest {
   $Repo = 'https://github.com/BRL-CAD/brlcad'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('rel-').replace('-','.')
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match '\.(msi|exe)'} | Select-Object -Last 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
      URL64   = $URL64
   }
}

function global:au_SearchReplace {
    @{
      "legal\VERIFICATION.md" = @{
         "(^- Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^- URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^- Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
    }
}


function global:au_BeforeUpdate() { 
   Write-host "Downloading BRL-CAD $($Latest.Version) installer"
   Get-RemoteFiles -Purge -nosuffix 
}

update -ChecksumFor none
