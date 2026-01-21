import-module chocolatey-au

function global:au_GetLatest {
   $DownloadPage = 'https://www.vosviewer.com/download'
   $PageData = Invoke-WebRequest -Uri $DownloadPage -UseBasicParsing

   $URL = $PageData.Links | 
            Where-Object {$_.href -match 'exe\.zip'} | 
            Select-Object -ExpandProperty href

   $version = $URL -replace ".*_([0-9.]+)_.*",'$1'

   return @{ Version = $version; URL32 = $url }
}


function global:au_SearchReplace {
   @{
      'legal\VERIFICATION.md' = @{
         '(^- Version :).*'         = "`${1} $($Latest.Version)"
         '(^- URL :).*'             = "`${1} $($Latest.URL32)"
         '(^- SHA256 Checksum :).*' = "`${1} $($Latest.Checksum32)"
      }
      'vosviewer.nuspec' = @{
         '(^\s+<docsUrl>.*_)[0-9.]+[0-9]'  = "`${1}$($Latest.Version)"
      }
   }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading VOSviewer $($Latest.Version) zip file."
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none
