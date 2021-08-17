import-module au

$DownloadURI = 'https://www.qgis.org/en/site/forusers/download.html'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $DownloadURI

   $null = $download_page.content.split("`n") | Where-Object {$_ -cmatch 'current version is QGIS ([0-9.]*)'}
   
   $NewRelease = $Matches[1]

   $url32 = $download_page.Links | 
               Where-Object {($_.href -match "QGIS.*x86\.exe`$") -and ($_.href -notmatch "$NewRelease")} | 
               Select-Object -ExpandProperty href
   $url64 = $download_page.Links | 
               Where-Object {($_.href -match "QGIS.*64\.exe`$") -and ($_.href -notmatch "$NewRelease")} | 
               Select-Object -ExpandProperty href

   $LTRversion = $url32 -replace ".*?-([0-9.]+)-.*",'$1'

   $SumURL32 = $download_page.Links |
        Where-Object {$_.href -match "$LTRversion.*x86\.exe.*\.sha256sum`$"} |
        Select-Object -ExpandProperty href
   $Sum32File = "$env:temp\QGIS$LTRVersion-x86SHA256.txt"
   Invoke-WebRequest $SumURL32 -OutFile $Sum32File
   $Checksum32 = (Get-Content $Sum32File -ReadCount 1).split()[0]

   $SumURL64 = $download_page.Links |
        Where-Object {$_.href -match "$LTRversion.*64\.exe.*\.sha256sum`$"} |
        Select-Object -ExpandProperty href
   $Sum64File = "$env:temp\QGIS$LTRVersion-x64SHA256.txt"
   Invoke-WebRequest $SumURL64 -OutFile $Sum64File
   $Checksum64 = (Get-Content $Sum64File -ReadCount 1).split()[0]

   return @{ 
            Version      = $LTRversion
            AppVersion   = $LTRversion
            URL32        = $url32
            URL64        = $url64
            Checksum32   = $Checksum32
            Checksum64   = $Checksum64
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]AppVersion = )('.*')"     = "`$1'$($Latest.AppVersion)'"
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
      "qgis-ltr.nuspec" = @{
         "^(\s*<releaseNotes>.*log)\d\d\d?(<\/releaseNotes>)" = "`${1}$(([version]($Latest.AppVersion)).tostring(2).Replace('.',''))`$2"
      }
   }
}

Update-Package -ChecksumFor none -NoCheckChocoVersion
