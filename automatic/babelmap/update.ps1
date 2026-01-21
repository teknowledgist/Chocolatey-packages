import-module chocolatey-au

function global:au_GetLatest {
   $ArchiveURL = 'https://www.babelstone.co.uk/Software/BabelMap_Versions.html'
   $List = Invoke-WebRequest -Uri $ArchiveURL -UseBasicParsing

   $null = $list.rawcontent -split '<\/?td' | 
                  Where-Object {$_ -match '>([0-9.]+$)'} | select -first 1
   $version = $matches[1]

   $URL32 = 'https://www.babelstone.co.uk/Software/Download/BabelMap.zip'

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
