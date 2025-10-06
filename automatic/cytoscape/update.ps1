import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/cytoscape/cytoscape'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $URL64 = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

# Sometimes there is no Windows build
if (-not $url64) { 
   $version = '1.0'
   $URL64,$CheckSum64 = $Release.Assets | Select-Object -First 1 -ExpandProperty DownloadURL,SHA256
} else { 
   $version = $Release.Tag.trim('v.')
   $CheckSum64 = $Release.SHA256
}


   return @{ 
      Version = $version
      URL64   = $URL64
      Checksum64 = $Checksum64
   }
}


function global:au_SearchReplace {
   @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor 64
