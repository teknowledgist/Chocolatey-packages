import-module au

$Release = 'http://support.bluebeam.com/articles/networkautomated-deployment-of-bluebeam-software/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $Fullname = $download_page.links | 
                  Where-Object -FilterScript {($_.href -match 'enterprise') -and ($_.innertext -match 'bluebeam')} |
                  select -ExpandProperty innertext -First 1

   $AppVersion = $Fullname.split()[-1]
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