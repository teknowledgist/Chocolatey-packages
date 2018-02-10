import-module au

$RootURL = 'https://ipmsg.org'

function global:au_GetLatest {
   $HomePage = Invoke-WebRequest -Uri "$RootURL/tools/fastcopy.html.en"

   $Text = $HomePage.allelements |Where-Object {
                                   ($_.tagname -eq 'th') -and 
                                   ($_.innertext -match "FastCopy.*download")
                                } | Select-Object -First 1 -ExpandProperty innertext
    
   $version = $Text -replace ".*v([\d\.]*).*",'$1'

   $Start32 = $HomePage.links | 
                Where-Object {($_.innertext -eq 'installer') -and ($_.onclick -match 'fc32')} |
                Select-Object -ExpandProperty href -First 1
   if ($Start32 -match 'vector') {
      $DownPage = Invoke-WebRequest -Uri $Start32
      $URL32 = $DownPage.links | 
                  Where-Object {$_.href -like '*.zip'} | 
                  Select-Object -First 1 -ExpandProperty href
   } else { 
      $URL32 = $Start32
   }

   $Start64 = $HomePage.links | 
                Where-Object {($_.innertext -eq 'installer') -and ($_.onclick -match 'fc64') -and ($_.href -match 'vector')} |
                Select-Object -ExpandProperty href -First 1
   if ($Start64 -match 'vector') {
      $DownPage = Invoke-WebRequest -Uri $Start64
      $URL64 = $DownPage.links | 
                  Where-Object {$_.href -like '*.zip'} | 
                  Select-Object -First 1 -ExpandProperty href
   } else {
      $URL64 = $Start64
   }

   return @{ 
            Version = $version
            URL32 = $url32
            URL64 = $url64
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"       = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"       = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*"  = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"       = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*"  = "`${1} $($Latest.Checksum64)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading FastCopy v$($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
