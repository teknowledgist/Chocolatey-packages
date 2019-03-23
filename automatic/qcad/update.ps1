import-module au

$Release = 'http://www.qcad.org/en/qcad-downloads-trial'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $download_page = Invoke-WebRequest -Uri $Release

   $url32,$url64 = $download_page.links |
                     ? {($_.href -match '\.msi$') -and ($_.innertext -NotMatch 'CAD\/CAM')} |
                     select -ExpandProperty href -First 2

   $version = ($url64 -split '-')[1]

   return @{ 
            Version = $version
            URL32 = $url32
            URL64 = $url64
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]Checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package