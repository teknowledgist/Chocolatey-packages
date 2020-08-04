import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/meganz/MEGAsync/releases'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $Link = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match 'Win\.zip"'} |
                Select-Object -First 1

   $version = $Link -replace '.*\/v([0-9.]+)_.*','$1'

   $URL32 = 'https://mega.nz/MEGAsyncSetup32.exe'
   $URL64 = 'https://mega.nz/MEGAsyncSetup64.exe'

   return @{ 
      Version = $version
      URL32 = $URL32
      URL64 = $URL64
   }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "^(   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "^(   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "^(   url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "^(   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package