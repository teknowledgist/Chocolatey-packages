import-module au

function global:au_GetLatest {
   $Release = 'https://www.rizonesoft.com/downloads/notepad3/'
   $PageText = Invoke-WebRequest -Uri $Release

   $TargetString = ($PageText.AllElements | 
                  Where-Object {($_.tagname -eq 'tr') -and ($_.innertext -match 'Replace Notepad')} |
                  Select-Object -ExpandProperty innertext
               ) -replace '.*Notepad(\S*).*','$1'

   $URL = $PageText.links |
               Where-Object {$_.innertext -match $targetString} |
               Select-Object -ExpandProperty href

   $Version = $targetString -replace '.*_([0-9.]+)\.exe.*','$1'

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
   Write-host "Downloading Notepad3_x_$($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase "Notepad3_x_$($Latest.Version)" 
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
