import-module au

$Release = 'https://sourceforge.net/projects/jmol/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = '^.*?/(.*?\.zip).*'
   $urlstub = ($download_page.links |? href -match 'latest' | select -ExpandProperty title) -replace $regex,'$1'
   $url = $Release + 'files/' + ($urlstub -replace ' ','%20')

   $version = ($urlstub -split '-')[1]

   $ReleaseNotes = $Release + 'files/Jmol/Version%20' + 
                              ($version.split('.')[0..1] -join '.') + 
                              '/Version%20' + $version + '/'

   return @{ Version = $version; URL = $url; RNotes = $ReleaseNotes }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
         "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      }
      "jmol.nuspec" = @{
         "^(\s*<releaseNotes>).*(<\/releaseNotes>)" = "`$1$($Latest.RNotes)`$2"
      }
   }
}

update -ChecksumFor 32