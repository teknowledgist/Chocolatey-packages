import-module chocolatey-au

$Release = 'https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $urls = $download_page.links |
                  ? {$_.innertext -match 'SKTimeStamp.*\.msi$'} | 
                  select -ExpandProperty href -First 2

   $version = $download_page.links |
                  ? {$_.innertext -match 'SKTimeStamp.*\.msi$'} | 
                  select -ExpandProperty innertext -First 1
   $version = $version.split('-')[-1].trim('.msi')

   return @{ Version = $version; URL = $urls[1]; URL64 = $urls[0] }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update