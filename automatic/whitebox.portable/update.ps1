import-module au

$Release = 'http://www.uoguelph.ca/~hydrogeo/Whitebox/download.shtml'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $Name = $download_page.allelements | Where-Object {
                                             ($_.tagname -match 'strong') -and 
                                             ($_.innertext -match "Whitebox GAT.*")
                                          } |
                Select-Object -ExpandProperty innertext -First 1

   $version = $Name.split()[-1]

   $url = 'https://www.uoguelph.ca/~hydrogeo/Whitebox/WhiteboxGAT-win.zip'

   return @{ 
            Version = $version
            URL     = $url
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
        }
    }
}

Update-Package