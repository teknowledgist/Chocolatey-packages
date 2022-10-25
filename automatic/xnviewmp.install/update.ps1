import-module au

function global:au_GetLatest {
   $Release = 'https://www.xnview.com/en/xnviewmp/'
   $download_page = Invoke-WebRequest -Uri $Release

   $URLs = $download_page.links |
               Where-Object {$_.href -match '\.exe'} |
               Select-Object -First 2 -ExpandProperty href

   $VersionText = $download_page.AllElements | 
                     Where-Object {$_.class -eq 'h5 fw-bold'} | 
                     Select-Object -First 1 -ExpandProperty innertext

   return @{ 
            Version = $VersionText.split()[0]
            URL32   = $URLs | Where-Object {$_ -notmatch 'x64'}
            URL64   = $URLs | Where-Object {$_ -match 'x64'}
           }
}


function global:au_SearchReplace {
    @{
      'legal\VERIFICATION.md' = @{
         '(- Version\s+:).*'    = "`${1} $($Latest.Version)"
         '(- x86 URL\s+:).*'    = "`${1} $($Latest.URL32)"
         '(- x86 SHA256\s+:).*' = "`${1} $($Latest.Checksum32)"
         '(- x64 URL\s+:).*'    = "`${1} $($Latest.URL64)"
         '(- x64 SHA256\s+:).*' = "`${1} $($Latest.Checksum64)"
      }
    }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
      Write-host "Downloading XnView MP $($Latest.Version) installer files"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none 
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
