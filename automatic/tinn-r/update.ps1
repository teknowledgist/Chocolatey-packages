import-module au

$Homepage = 'http://nbcgib.uesc.br/lec/software/editores/tinn-r/en'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Homepage

   $Link = $download_page.links | 
                  Where-Object -FilterScript {($_.href -match 'setup.exe') -and ($_.innertext -cmatch 'Tinn-R')} |
                  select -First 1

   $Version = ([version]$link.innerText.split('_')[1]).ToString()

   $url = ([uri]$Homepage).scheme,'://',([uri]$Homepage).host,$Link.href -join ''

   return @{ 
            Version    = $Version
            URL32      = $url
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]URL\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^[$]Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

Update-Package