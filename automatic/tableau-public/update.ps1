import-module au

function global:au_GetLatest {
   $ReleasesURL = 'https://www.tableau.com/support/releases'
   $ReleasesPage = Invoke-WebRequest -Uri $ReleasesURL
   $innertext = $releasespage.links | 
                     Where-Object {$_.innertext -match 'current version'} | 
                     Select-Object -ExpandProperty innertext
   $Version = $innertext.split()[-1]

   $URL64 = "https://downloads.tableau.com/public/TableauPublicDesktop-64bit-$($Version.replace('.','-')).exe"
   
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
