import-module au

$RootURL = 'https://ipmsg.org'

function global:au_GetLatest {
   $HomePage = Invoke-WebRequest -Uri "$RootURL/tools/fastcopy.html.en"

   $Down32 = Invoke-WebRequest -uri ($HomePage.links | 
                  Where-Object {$_.onclick -match "log\('fc32_vector"} |
                  select -First 1 -ExpandProperty href
             )
   $url32 = $Down32.links | Where-Object {$_.href -match '.*\.zip'} |select -ExpandProperty href

   $Down64 = Invoke-WebRequest -uri ($HomePage.links | 
                  Where-Object {$_.onclick -match "log\('fc64_vector"} |
                  select -First 1 -ExpandProperty href
             )
   $url64 = $Down64.links | Where-Object {$_.href -match '.*\.zip'} |select -ExpandProperty href

   $Text = $HomePage.allelements |? {
                                   ($_.tagname -eq 'th') -and 
                                   ($_.innertext -match "FastCopy.*download")
                                } | select -First 1 -ExpandProperty innertext
    
   $version = $Text -replace ".*v([\d\.]*).*",'$1'

   return @{ 
            Version = $version
            URL32 = $url32
            URL64 = $url64
           }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"          = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"          = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*"     = "`${1} $($Latest.Checksum64)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading FastCopy $($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
