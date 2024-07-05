import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://learn.microsoft.com/en-us/visualstudio/vsto/visual-studio-tools-for-office-runtime?view=vs-2022'
   $VersionPage = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $table = $VersionPage.content -split 'table>' | Where-Object {$_ -match 'vsto runtime version'}
   $VersionString = $table -split 'td>' | Where-Object {$_ -match '^[0-9.]+<'} | Select-Object -last 1
   $Version = $VersionString -replace '[^0-9.]',''
   
   $DownloadURL = $VersionPage.links | Where-Object {$_.href -match 'download'} | Select-Object -ExpandProperty href
   $DownloadURL = 'https://aka.ms/VSTORuntimeDownload'
   $DownloadPage = iwr -Uri $DownloadURL 
   $URL32 = $DownloadPage.RawContent.split('"') | ? {$_ -match '^http.*?\.exe$'} | select -Last 1

   return @{ 
      Version = $Version
      URL32   = $url32
   }
}


function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
       }
    }
}

Update-Package