import-module au

$Release = 'https://github.com/garybentley/quollwriter/releases/latest'

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $null = $download_page.Links | Where-Object {$_.outerhtml -match 'Version ([0-9.]+)'}
   $version = $Matches[1]

   $url = "http://quollwriter.com/download/windows/"

   return @{ 
      Version  = $version
      URL32    = $url 
      FileType = 'exe'
   }
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

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Quoll Writer $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase "QuollWriter-install-$($Latest.Version)"
   }

   Update-Package -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
