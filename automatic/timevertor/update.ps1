import-module au


function global:au_GetLatest {
   $Release = 'https://github.com/henrypp/timevertor/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split("<>") | 
                Where-Object {$_ -match 'bin\.zip"'} |
                Select-Object -First 1
   $url = "https://github.com" + $($urlstub -replace '.*?"([^ ]+\.zip).*','$1')

   $version = ($urlstub -split '-')[1]

   $CheckFile = $url -replace "-bin\.zip",'.sha256'
   $TempSum = "$env:temp\timevertor.SHA256.txt"
   Invoke-WebRequest $CheckFile -OutFile $TempSum
   $Checksum32 = (Get-Content $TempSum | Where-Object {$_ -like '*bin.zip'}).split()[0]

   return @{ 
            Version    = $version
            URL32      = $url
            Checksum32 = $Checksum32
            Checkfile  = $CheckFile
           }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^SHA256\s+:).*"       = "`${1} $($Latest.Checksum32)"
         "(^\d\. )https.*256$"   = "`${1}$($Latest.Checkfile)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading TimeVertor v$($Latest.Version) zip file"
   Get-RemoteFiles -Purge -NoSuffix 
}

update -ChecksumFor none
