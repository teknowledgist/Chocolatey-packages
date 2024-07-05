import-module chocolatey-au

$MainURL = 'https://www.nasm.us/'

function global:au_GetLatest {
   $MainPage = Invoke-WebRequest -Uri $MainURL

   $FolderLink = $MainPage.links | 
                  Where-Object {$_.href -match '/([0-9.]+)/'} | 
                  Select-Object -First 1 -ExpandProperty href

   $version = $Matches[1]

   $url32 = "$FolderLink/win32/nasm-$version-installer-x86.exe"
   $url64 = "$FolderLink/win64/nasm-$version-installer-x64.exe"

   return @{ 
      Version = $version
      URL32   = $url32
      URL64   = $url64
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
            "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
            "(^x86 URL\s+:).*"      = "`${1} $($Latest.URL32)"
            "(^x86 Checksum\s+:).*" = "`${1} $($Latest.Checksum32)"
            "(^x64 URL\s+:).*"      = "`${1} $($Latest.URL64)"
            "(^x64 Checksum\s+:).*" = "`${1} $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading NASM $($Latest.Version) installer files"
   Get-RemoteFiles -Purge -nosuffix
}

update -ChecksumFor none
