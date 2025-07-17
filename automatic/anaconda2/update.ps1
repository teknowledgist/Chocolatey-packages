import-module chocolatey-au

function global:au_GetLatest {
   $ArchiveURL = 'https://repo.continuum.io/archive/'
   $List = Invoke-WebRequest -Uri $ArchiveURL

   $version = "1.0"

   $List.links | Where-Object {$_.href -match "Anaconda2.*Windows"} | 
      ForEach-Object {
         $v = ($_.href.split('-')[1])
         if ([version]$v -gt [version]$version) {$version = $v}
      }

   $URL32 = "https://repo.continuum.io/archive/Anaconda2-$version-Windows-x86.exe"
   $URL64 = "https://repo.continuum.io/archive/Anaconda2-$version-Windows-x86_64.exe"

   return @{ 
            Version  = $Version
            URL32    = $URL32
            URL64    = $URL64
            Options  = @{
               Headers = @{
                  'authority' = 'repo.anaconda.com'
                  'referer'   = 'https://repo.anaconda.com/archive/'
                  'user-agent'= 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
               }
            }
   }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor all
