Import-Module -Name Evergreen
Import-Module -Name Chocolatey-AU

function global:au_GetLatest {
   $Meta = Get-EvergreenApp qgis

   $LatestQGIS = $Meta | Where-Object {$_.channel -eq 'latest'}
   $LTRQGIS = $Meta | Where-Object { $_.channel -eq 'ltr' }

   $NewVersion = $LatestQGIS.version -replace '-1$',''
   $SumURL = $LatestQGIS.URI -replace '\.msi$','.sha256sum'
   
   $SumFile = "$env:temp\QGIS$NewVersion-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   Write-Host "LTR version: $($LTRQGIS.version)"

   return @{ 
      Version    = $NewVersion
      LTRVersion = $LTRQGIS.version -replace '-1$', ''
      URL64      = $LatestQGIS.URI
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