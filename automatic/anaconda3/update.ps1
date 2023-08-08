import-module au

function global:au_GetLatest {
   $ArchiveURL = 'https://repo.anaconda.com/archive/'
   $List = Invoke-WebRequest -Uri $ArchiveURL

   $version = "1.0"

   $List.links | Where-Object {$_.href -match "Anaconda3.*Windows"} | 
      ForEach-Object {
         $vstring = $_.href -replace 'Anaconda3-([0-9.-]+)-Windows.*','$1'
         $v = $vstring -replace '-','.'
         if ([version]$v -gt [version]$version) {
            $version = $v
            $versionString = $vstring
         }
      }

   $URL64 = "https://repo.anaconda.com/archive/Anaconda3-$versionString-Windows-x86_64.exe"

   return @{ 
            Version  = $Version
            URL64    = $URL64
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -ChecksumFor 64
