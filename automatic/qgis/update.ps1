import-module chocolatey-au

function global:au_GetLatest {
   $downloaduri = 'https://www.qgis.org/en/site/forusers/alldownloads.html'
   $download_page = Invoke-WebRequest -Uri $DownloadURI

#   $null = $download_page.content.split("`n") | Where-Object {$_ -cmatch 'current version is QGIS ([0-9.]*)'}
   
#   $NewVersion = $Matches[1]

   $row = $download_page.AllElements | ? {($_.tagname -eq 'tr') -and ($_.innertext -match 'latest release.*installer')}
   $url = $row.outerhtml.split('"') | ? {$_ -match '/downloads/.*\.msi$'}
   $SumURL = $row.outerhtml.split('"') | ? {$_ -match '/downloads/.*\.sha256sum$'}

   $SumFile = "$env:temp\QGIS$NewVersion-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   $NewVersion = $url.split('-') | ? {$_ -match '^[0-9.]+$'}

   $LTRrow = $download_page.AllElements | ? {($_.tagname -eq 'tr') -and ($_.innertext -match 'long term release.*installer')}
   $LTRurl = $LTRrow.outerhtml.split('"') | ? {$_ -match '/downloads/.*\.msi$'}
   $LTRversion = $LTRurl.split('-') | ? {$_ -match '^[0-9.]+$'}

   return @{ 
      Version    = $NewVersion
      LTRVersion = $LTRversion
      URL64      = $url
      Checksum64 = $Checksum64
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]LTRversion = )('.*')"     = "`$1'$($Latest.LTRversion)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}

Update-Package -NoCheckUrl -ChecksumFor none