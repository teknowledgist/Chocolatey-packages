 import-module chocolatey-au

$Release = 'http://www.qcad.org/en/qcad-downloads-trial'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $ChangeLogURL = 'https://www.qcad.org/en/changelog/'
   $ChangeLog = Invoke-WebRequest -Uri $ChangeLogURL -UseBasicParsing
   
   $Null = $ChangeLog.content.split('<>') | Where-Object {$_ -match '^/?h3'} |
                                            Where-Object {$_ -match 'id="v([0-9.]+)' } |
                                            Select-Object -first 1
   $Version = $Matches[1]
   
#   $url32 = "https://www.qcad.org/archives/qcad/qcad-$($Version)-trial-win32-installer.msi"
   $url64 = "https://www.qcad.org/archives/qcad/qcad-$($Version)-trial-win64-qt6-installer.msi"

   $FakeURL = 'https://cdn.jsdelivr.net/gh/qcad/qcad@120b14d6d2f79d4332f528d5dcd908137dc60f14/support/doc/api/qcad_icon.png'

   return @{ 
            Version   = $Version
#            URL32     = $FakeURL
            URL64     = $FakeURL
#            RealURL32 = $url32
            RealURL64 = $url64
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
#            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.RealURL32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.RealURL64)'"
#            "(^[$]Checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_BeforeUpdate() { 
   Write-Warning "New QCad version:  $($Latest.Version)"
}

Update-Package -ChecksumFor 64