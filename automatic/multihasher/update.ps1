import-module au

function global:au_GetLatest {
   $HomeURL = 'http://www.abelhadigital.com/multihasher/'
   $page = Invoke-WebRequest -Uri $HomeURL

   $string = $page.allelements | 
               Where-Object {$_.tagname -eq 'p' -and $_.class -eq 'version'} | 
               Select-Object -ExpandProperty innertext -First 1

   $version = $string.split() | Where-Object {$_ -match '^[0-9.]+$'}

   $URL32 = $page.allelements | Where-Object {
                                 ($_.tagname -eq 'a') -and 
                                 ($_.outertext -match '^\s*Installer') -and 
                                 ($_.href -match 'drive.google')} |
                              Select-Object -ExpandProperty href
   $URL32 = $URL32 -replace '&amp;','&'

   return @{ 
            Version  = $Version
            URL32    = $URL32
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^[$]Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor 32
