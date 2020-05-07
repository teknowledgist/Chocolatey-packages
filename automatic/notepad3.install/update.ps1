import-module au

function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

   $downloaduri = 'https://www.rizonesoft.com/downloads/notepad3/'
   $download_page = Invoke-WebRequest -Uri $DownloadURI -UseBasicParsing   
   $link64 = $download_page.links | Where-Object {$_.class -match 'exe'} | Select-Object -First 1   
   $link32 = $download_page.links | 
                  Where-Object {($_.class -match 'exe') -and ($_.outerhtml -match 'x86')} | 
                  Select-Object -First 1   

   $version = $link64.title.split()[-1]
   $filename64 = $link64.outerhtml.split() | Where-Object {$_ -match '\.exe$'}
   $filename32 = $link32.outerhtml.split() | Where-Object {$_ -match '\.exe$'}
   
   $url64 = "https://www.rizonesoft.com/software/notepad3/" + $filename64
   $url32 = "https://www.rizonesoft.com/software/notepad3/" + $filename32

   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
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
   Write-host "Downloading Notepad3 $($Latest.Version) files."
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase "Notepad3_$($Latest.Version)" 
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
