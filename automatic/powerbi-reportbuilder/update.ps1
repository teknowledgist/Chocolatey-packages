import-module chocolatey-au

function global:au_GetLatest {
   $ProductID = '105942'
   $MainURL = "https://www.microsoft.com/en-us/download/details.aspx?id=$ProductID"
   $MainPage = Invoke-WebRequest -Uri $MainURL -UseBasicParsing

   $null = $mainpage.RawContent -split ',' | Where-Object {$_ -match '"version":"([0-9.]+)"'} | Select-Object -First 1
   $version = $matches[1]

   $null = $mainpage.RawContent -match '"url":"([^"]+)"'
   $url32 = $matches[1]
   $CSV = @('Code,Language,URL,SHA256')
   $CSV += "en-EN,English,$url32"

   return @{
      Version  = $Version
      URL32    = $URL32
   }
}

function global:au_SearchReplace {
   @{
      'tools\chocolateyInstall.ps1' = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -ChecksumFor all
