Import-Module -Name Evergreen
Import-Module -Name Chocolatey-AU

function global:au_GetLatest {
   $Meta = Get-EvergreenApp qgis

   $LTRQGIS = $Meta | Where-Object { $_.channel -eq 'ltr' }

   $Version = $LTRQGIS.version -replace '-1$', ''
   $SumURL = $LTRQGIS.URI -replace '\.msi$', '.sha256sum'
   
   $SumFile = "$env:temp\QGIS$Version-SHA256.txt"
   Invoke-WebRequest $SumURL -OutFile $SumFile -UseBasicParsing
   $Checksum64 = (Get-Content $SumFile -ReadCount 1).split()[0]

   return @{ 
            Version      = $Version
            AppVersion   = $Version
            URL64        = $LTRQGIS.URI
            Checksum64   = $Checksum64
           }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]AppVersion = )('.*')"     = "`$1'$($Latest.AppVersion)'"
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
      "qgis-ltr.nuspec" = @{
         "^(\s*<releaseNotes>.*log)\d\d\d?(<\/releaseNotes>)" = "`${1}$(([version]($Latest.AppVersion)).tostring(2).Replace('.',''))`$2"
      }
   }
}

Update-Package -ChecksumFor none -NoCheckChocoVersion
