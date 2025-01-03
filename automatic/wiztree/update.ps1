import-module chocolatey-au

function global:au_GetLatest {
   $NewURL = 'https://www.diskanalyzer.com/whats-new'
   $PageText = Invoke-WebRequest -Uri "$NewURL" -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($PageText.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($PageText))   # No MS Office
   }

   $Release = $HTML.getElementsByTagName('h4') | 
                  Where-Object {$_.innertext -match '^wiztree'} | 
                  Select-Object -ExpandProperty innertext -first 1

   $Version = $Release.split()[1]

   $URL = "https://www.diskanalyzer.com/files/wiztree_$($version.replace('.','_'))_setup.exe"

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
