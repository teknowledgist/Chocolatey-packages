import-module au

function global:au_GetLatest {
   $ReleaseURL = 'https://www.pinta-project.com/releases/'
   $PageText = Invoke-WebRequest -Uri $ReleaseURL

   $URL = $PageText.links | Where-Object {$_.href -match '\.exe'} |Select-Object -ExpandProperty href

   $Version = $URL.split('/') | Where-Object {$_ -match '^[0-9.]+$'}

   return @{ 
            Version  = $Version
            URL32    = $URL
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Pinta $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
