import-module au

$Release = 'https://sourceforge.net/projects/icopy/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = '^.*?/(.*?\.exe).*'
   $urlstub = ($download_page.links |? href -match 'latest' | select -ExpandProperty title) -replace $regex,'$1'

   $version = ($urlstub -split '/')[1]

   return @{ Version = $version }
}


function global:au_SearchReplace {
    @{
    }
}

update -ChecksumFor 32