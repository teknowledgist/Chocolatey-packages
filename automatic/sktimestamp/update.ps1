import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urls = $download_page.links |
                  Where-Object {$_.outerhtml -match 'SKTimeStamp.*\.msi<'} | 
                  select -ExpandProperty href -First 2

   $version = $urls[0] -replace '.*-([0-9.]+)\.msi.*','$1'

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