import-module au

$Release = 'https://github.com/clechasseur/pathcopycopy/releases/latest'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.links |? {$_.href -match '.exe$'} | select -ExpandProperty href -First 1
   $url = "https://github.com$urlstub"

   $version = $urlstub.split('/') | ? {$_ -match '^v?[0-9.]+$'} | select -Last 1
   $version = $version.trim('v')

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading PathCopyCopy $($Latest.Version) installer file"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
