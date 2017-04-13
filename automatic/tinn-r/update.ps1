import-module au

$FilesPage = 'https://sourceforge.net/projects/tinn-r/files/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $FilesPage

   $Link = $download_page.links | Where-Object {$_.innertext -match 'setup.exe'} | select -First 1

   $Version = ([version]$link.innerText.split('_')[1]).ToString()

   $url = ([uri]$FilesPage).scheme,'://',([uri]$FilesPage).host,$Link.href -join ''

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