import-module chocolatey-au

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

   $FakeURL = 'https://cdn.jsdelivr.net/gh/qcad/qcad@120b14d6d2f79d4332f528d5dcd908137dc60f14/support/doc/api/qcad_icon.png'

   return @{ 
            Version   = $newversion
            URL32     = $FakeURL
            URL64     = $FakeURL
            RealURL32 = $url32
            RealURL64 = $url64
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.RealURL32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.RealURL64)'"
            "(^[$]Checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_BeforeUpdate() { 
   Write-Warning "New QCad version:  $($Latest.Version)"
}

Update-Package