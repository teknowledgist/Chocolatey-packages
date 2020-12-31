import-module au

function global:au_GetLatest {
   $GitURL = 'https://github.com/meganz/MEGAsync/releases'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $GitPage = Invoke-WebRequest -Uri $GitURL -UseBasicParsing

   $Link = $GitPage.rawcontent.split("<>") | 
                Where-Object {$_ -match 'Win\.zip"'} |
                Select-Object -First 1

   $GitVersion = $Link -replace '.*\/v([0-9.]+)_.*','$1'

   $SPurl = 'https://www.softpedia.com/get/Internet/File-Sharing/MEGAsync.shtml'
   $SPpage = Invoke-WebRequest -Uri $SPurl
   $SPlink = $SPpage.links | Where-Object {$_.innertext -match 'download megasync'} | 
                  Select-Object -ExpandProperty innertext -first 1
   $SPversion = $SPlink -replace ".* ([0-9.]+) .*",'$1'

   $version = ([version]$GitVersion,[version]$SPversion | Measure-Object -Maximum).Maximum.ToString()

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