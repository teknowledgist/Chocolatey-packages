import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/goastian/midori-desktop'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'win64\.installer\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

# Sometimes there is no Windows build
if (-not $url64) { 
   $version = '1.0'
   $URL64 = $Release.Assets | Select-Object -First 1 -ExpandProperty DownloadURL
} else { 
   $version = $Release.Tag.trim('v.')
}


   return @{ 
      Version = $version
      URL64   = $URL64
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
