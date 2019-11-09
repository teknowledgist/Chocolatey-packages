import-module au

function global:au_GetLatest {
   $HomeURL = 'https://antibody-software.com/web/software/software/wiztree-finds-the-files-and-folders-using-the-most-disk-space-on-your-hard-drive/'
   $PageText = Invoke-WebRequest -Uri $HomeURL

   $Stub = $PageText.links | ? {$_.href -match 'wiztree.*\.exe'} |select -ExpandProperty href

   $URL = "https://antibody-software.com$Stub"

   $Version = ($Stub -replace '.*?([0-9._]+).*?\.exe.*','$1' -replace '_','.').trim('.')

   return @{ 
            Version  = $Version
            URL32    = $URL
            FileType = 'exe'
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
   Write-host "Downloading WizTree $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
