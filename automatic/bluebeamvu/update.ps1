import-module au

$Release = 'http://support.bluebeam.com/downloads-and-updates/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $html = $download_page.AllElements | 
                  Where-Object -FilterScript {($_.tagname -eq 'tr') -and ($_.innertext -match '^Vu')} | 
                  Select-Object -ExpandProperty innerhtml -First 1

   $AppVersion = (($html.split("`n") |? {$_ -match 'center'}) -replace '.*>(.*)<.*','$1').trim()

   $PackageVersion = $AppVersion
   if ($AppVersion.split('.').count -eq 1) {
      $PackageVersion += '.0'
   }

   $url = "https://downloads.bluebeam.com/software/downloads/$AppVersion/vu/BbVu$AppVersion.exe"

   return @{ 
            Version    = $PackageVersion
            URL32      = $url
            AppVersion = $AppVersion
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]URL\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^[$]Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]AppVersion\s*=\s*)('.*')" = "`$1'$($Latest.AppVersion)'"
        }
    }
}

Update-Package