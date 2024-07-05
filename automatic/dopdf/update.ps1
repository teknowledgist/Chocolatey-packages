import-module chocolatey-au

function global:au_GetLatest {
   $HomeURL = 'http://www.dopdf.com/'
   $page = Invoke-WebRequest -Uri $HomeURL -UseBasicParsing

   $null = $page.rawcontent -match 'version (\d+\.\d+\.\d+)'

   $version = $Matches[1]

   $URL32 = 'https://download.dopdf.com/download/setup/dopdf-full.exe'

   return @{ 
            Version  = $Version
            URL32    = $URL32
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor all
