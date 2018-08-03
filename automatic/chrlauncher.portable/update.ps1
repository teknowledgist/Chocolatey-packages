import-module au

$Release = 'https://github.com/henrypp/chrlauncher/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match 'chrlauncher-.*?-bin\.zip"'} |
                Select-Object -First 1
   $url = "https://github.com" + $($urlstub -replace '.*?"([^ ]+\.zip).*','$1')

   $version = ($urlstub -split '-')[1]

   $CheckFile = $url -replace "-bin\.zip",'.sha256'

   return @{ 
            Version   = $version
            URL32     = $url
            Checkfile = $CheckFile
           }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
         "^https.*sha256"        = "$($Latest.Checkfile)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading ChrLauncher v$($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
