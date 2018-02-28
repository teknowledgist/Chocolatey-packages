import-module au

function global:au_GetLatest {
   $Release = 'https://www.rizonesoft.com/downloads/notepad3/'
   $PageText = Invoke-WebRequest -Uri $Release

   $HREF = $PageText.links | ? {$_.innertext -match 'Notepad3.*Setup\.zip'} | select -First 1

   $Version = $href.innertext -replace '.*_([0-9.]+)_.*\.zip.*','$1'

   $URL = $HREF | Select-Object -ExpandProperty href
   $URL = $URL + "?version=" + $Version.replace('.','-')

   return @{ 
            Version  = $Version
            URL32    = $URL
            FileType = 'zip'
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
   Write-host "Downloading Notepad3 $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase "Notepad3_$($Latest.Version)" 
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
