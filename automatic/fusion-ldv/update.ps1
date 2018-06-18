import-module au

function global:au_GetLatest {
   $Release = 'http://forsys.sefs.uw.edu/fusion'
   $PageText = Invoke-WebRequest -Uri "$Release/fusionlatest.html"

   $HREF = $PageText.links |
               Where-Object {($_.href -match '\.exe') -and ($_.href -notmatch 'example')} |
               Select-Object -ExpandProperty href

   $null = $PageText.rawcontent.split("`n") | Where-Object {$_ -match 'Version ([0-9.]+) is the latest version'}
   $Version = $Matches[1]

   $URL = "$Release/$HREF"

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
   Write-host "Downloading Fusion-LDV $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
