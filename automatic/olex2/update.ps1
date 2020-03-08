import-module au

$Release = 'http://www.olex2.org/olex2-distro/1.3/update/version.txt'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $Revision = $download_page.Content -replace "^.*?(\d+)$",'$1'
   $version = '1.3.0.' + $Revision

   $url32 = 'http://www.olex2.org/olex2-distro/1.3/olex2-win32.zip'
   $url64 = 'http://www.olex2.org/olex2-distro/1.3/olex2-win64.zip'

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
         "(^[$]checkSum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
         "(^[$]checkSum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_BeforeUpdate() { 
   Write-Warning "Grabbing Olex splash screen with version number."
   Write-Warning "Be sure to confirm the Olex version before submitting!"
   $OutFile  = Join-Path (Resolve-Path .) 'splash.jpg'
   $URI      = ((split-path $Release) -replace '\\','/') + '/splash.jpg'
   Invoke-WebRequest $URI -OutFile $OutFile
}

Update-Package