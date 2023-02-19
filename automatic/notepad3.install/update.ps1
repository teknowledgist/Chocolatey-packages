import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/rizonesoft/Notepad3'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = ($Release.Tag -replace '.*?([0-9.]+).*','$1').trim('.')
   $URL32 = $Release.Assets | 
               Where-Object {$_.FileName -match 'x86_Setup\.exe'} | 
               Select-Object -First 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | 
               Where-Object {$_.FileName -match 'x64_Setup\.exe'} | 
               Select-Object -First 1 -ExpandProperty DownloadURL

   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
            FileType = 'zip'
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
      Get-RemoteFiles -Purge
   }

   update -ChecksumFor none -NoCheckChocoVersion
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
