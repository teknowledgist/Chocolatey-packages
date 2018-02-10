import-module au

function global:au_GetLatest {
   $Release = 'http://ditto-cp.sourceforge.net/index.php'
   $PageText = Invoke-WebRequest -Uri $Release

   $DownURL = $PageText.links | ? {$_.innertext -eq 'Download'} |select -ExpandProperty href
   $Version = $DownURL.split('/') | ? {$_ -match '^[0-9.]+$'}

   $URLBase = 'https://sourceforge.net/projects/ditto-cp/'

   $URL32 = $URLBase + 'files/DittoSetup_' + $Version.replace('.','_') + '.exe'
   $URL64 = $URLBase + 'files/DittoSetup_64bit_' + $Version.replace('.','_') + '.exe'

   return @{ 
            Version  = $Version
            URL32    = $URL32
            URL64    = $URL64
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Ditto $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix 
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
