import-module au

$Release = 'http://www.qcad.org/en/qcad-downloads-trial'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $download_page = Invoke-WebRequest -Uri $Release

   $Stub32,$Stub64 = $download_page.links |
                     Where-Object {($_.href -match '\.msi$') -and ($_.innertext -NotMatch 'CAD\/CAM')} |
                     Select-Object -ExpandProperty href -First 2
   
   $url32 = "https://www.qcad.org$Stub32"
   $url64 = "https://www.qcad.org$Stub64"
   $newversion = ($stub64 -split '-')[1]

   $oldversion = '3.24.0'
   if ([version]$newversion -ne [version]$oldversion) {
      Write-Warning "New QCad version:  $version"
   } else {
      $url32 = $url64 = 'https://cdn.jsdelivr.net/gh/qcad/qcad@120b14d6d2f79d4332f528d5dcd908137dc60f14/support/doc/api/qcad_icon.png'
   }
   
   return @{ 
            Version = $newversion
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