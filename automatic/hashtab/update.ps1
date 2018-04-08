import-module au

function global:au_GetLatest {
   $Release = 'http://implbits.com/products/hashtab/'
   $PageText = Invoke-WebRequest -Uri $Release

   $stub = $PageText.links | ? {$_.innertext -match 'download'} | select -ExpandProperty href

   $Version = $stub -replace '.*_v([0-9.]+)_.*','$1'

   $URL = $Release + $stub

   return @{ 
            Version    = $Version
            AppVersion = $Version
            URL32      = $URL
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.AppVersion)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading HashTab $($Latest.AppVersion)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
