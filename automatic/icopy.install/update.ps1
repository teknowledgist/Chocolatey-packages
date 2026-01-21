import-module chocolatey-au

$Release = 'https://sourceforge.net/projects/icopy/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $version = ($download_page.links |
                ? href -match 'latest' | 
                select -ExpandProperty title) -replace '^.*icopy([0-9.]*).*','$1'
   $url = "https://sourceforge.net/projects/icopy/files/iCopy/$version/iCopy$($version)setup.exe"

   return @{ Version = $version; URL32 = $url }
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
   Write-host "Downloading iCopy $($Latest.Version)"
      Get-RemoteFiles -Purge
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
