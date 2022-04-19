import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/Lymphatus/caesium-image-compressor/releases'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $urlstub = $download_page.rawcontent.split('"') | 
                Where-Object {$_ -match '\.exe$'} |
                Select-Object -First 1
   $url = "https://github.com$urlstub"

   $version = $urlstub.split('/') | ? {$_ -match '^v[0-9].*$'} | select -Last 1
   $version = $version.trim('v') -replace '\.(\d)$','$1'

   return @{ Version = $version; URL64 = $url }
}


function global:au_SearchReplace {
   @{
      "legal\VERIFICATION.md" = @{
         "(^Version\s+:).*"  = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^SHA256\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
      Write-host "Downloading Caesium $($Latest.Version) installer file"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
