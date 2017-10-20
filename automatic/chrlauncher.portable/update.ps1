import-module au

$Release = 'https://github.com/henrypp/chrlauncher/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release

   $regex = 'chrlauncher-.*?-bin.zip'
   $urlstub = $download_page.links |Where-Object {$_.href -match $regex} |Select-Object -ExpandProperty href
   $url = "https://github.com/$urlstub"

   $version = ($urlstub -split '-')[1]

   $CheckFile = $url -replace "-bin\.zip",'.sha256'

   return @{ Version = $version; URL = $url; Checkfile = $CheckFile}
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
   Get-RemoteFiles -Purge -NoSuffix -FileNameBase "Jmol-$($Latest.Version)-binary" 
}

update -ChecksumFor none
