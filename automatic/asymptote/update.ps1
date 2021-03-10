import-module au

function global:au_GetLatest {
   $Release = 'https://sourceforge.net/projects/asymptote/files/'
   $Files_page = Invoke-WebRequest -Uri $Release

   $Title = $Files_page.links |
                Where-Object {$_.innertext -match 'latest version'} | 
                Select-Object -ExpandProperty title
   $version = $Title.split('/')[1]

   $URL32 = "https://sourceforge.net/projects/asymptote/files/$version/asymptote-$($version)-setup-32.exe"
   $URL64 = "https://sourceforge.net/projects/asymptote/files/$version/asymptote-$($version)-setup.exe"

   return @{ 
         Version = $version
         URL32   = $URL32
         URL64   = $URL64
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
   Write-host "Downloading Asymptote $($Latest.Version) installer files."
   Get-RemoteFiles -Purge -NoSuffix
}

Update-Package -ChecksumFor none
