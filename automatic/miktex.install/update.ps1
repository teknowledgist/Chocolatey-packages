import-module au

function global:au_GetLatest {
   $DownloadPageURL = 'https://miktex.org/download'

   $DownloadPage = Invoke-WebRequest -Uri $DownloadPageURL

   $URLstub = $DownloadPage.links | 
                  Where-Object {$_.href -match 'zip'} | 
                  Select-Object -ExpandProperty href -Unique

   $url64 = 'https://miktex.org' + $URLstub
   # The version number in the url is the version of the setup utility, but not
   #   the "milestone" of the MiKTeX core run-time library.
   $Repo = 'https://github.com/MiKTeX/miktex'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $milestone = $Release.Tag.trim('v.')

   return @{ 
      Milestone = $milestone
      Version   = $milestone
      URL64     = $url64 
   }
}

function global:au_SearchReplace {
   @{
      'tools\VERIFICATION.txt' = @{
         "(^Milestone\s*=\s*)('.*')"            = "`$1'$($Latest.Milestone)'"
         "(^64-bit URL\s*=\s*)('.*')"           = "`$1'$($Latest.URL64)'"
         "(^64-bit checksum\s*=\s*)('.*')"      = "`$1'$($Latest.Checksum64)'"
      }
      'tools\ChocolateyInstall.ps1' = @{
         "(^[$]PackageMileStone\s*=\s*)('.*')"  = "`$1'$($Latest.Milestone)'"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
      Write-host "Downloading Setup Utility for MiKTeX milestone $($Latest.Milestone)."
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
