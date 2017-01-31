import-module au

$Release = 'https://sourceforge.net/projects/jmol/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = '^.*?/(.*?\.zip).*'
   $urlstub = ($download_page.links |? href -match 'latest' | select -ExpandProperty title) -replace $regex,'$1'
   $url = 'https://sourceforge.net/projects/jmol/files/' + ($urlstub -replace ' ','%20')

   $version = ($urlstub -split '-')[1]

   return @{ Version = $version; URL = $url }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update -ChecksumFor 32