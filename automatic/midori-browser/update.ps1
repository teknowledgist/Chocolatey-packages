import-module chocolatey-au

function global:au_GetLatest {
   $Repo = 'https://github.com/goastian/midori-desktop'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = $Release.Tag.trim('v.')
#   $URL32 = $Release.Assets | Where-Object {$_.FileName -match 'win32\.installer\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | Where-Object {$_.FileName -match 'win64\.installer\.exe'} | Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
      Version = $version
#      URL32   = $URL32
      URL64   = $URL64
   }
}


function global:au_SearchReplace {
   @{
       "tools\chocolateyInstall.ps1" = @{
#          "(^\s*Url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
#          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
          "(^\s*Url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor 64
