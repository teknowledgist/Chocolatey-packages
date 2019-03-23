import-module au

$Announcement = 'http://www.3ds.com/products-services/draftsight-cad-software/latest-version/'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri $Announcement

   $Headline = $download_page.AllElements | 
                  Where-Object -FilterScript {($_.tagname -eq 'h1') -and ($_.innertext -match 'DraftSight® Latest Release')} | 
                  Select-Object -ExpandProperty innertext -First 1

   $AppVersion = $Headline.split(':')[-1] -replace '.*(\d\d\d\d.*)','$1'
   $PackageVersion = $AppVersion.split()[0] + '.0' + ($AppVersion -replace '.*SP(.*)','$1')
   $LinkVersion = $AppVersion.replace(' ','') -replace 'SP([1-9])','SP$1'

   $ReleaseNotes = $download_page.links | 
                  Where-Object -FilterScript {($_.href -match $AppVersion.replace(' ','_')) -and ($_.href -match 'Release_Notes')} | 
                  Select-Object -ExpandProperty href -First 1
   $ReleaseNotes = 'https:\\www.3ds.com\' + $ReleaseNotes

   $Requirements = $download_page.links | 
                  Where-Object -FilterScript {($_.href -match $AppVersion.replace(' ','_')) -and ($_.href -match 'Requirements')} | 
                  Select-Object -ExpandProperty href -First 1
   $Requirements = 'https:\\www.3ds.com\' + $Requirements

   $url = "http://dl-ak.solidworks.com/nonsecure/draftsight/$LinkVersion/DraftSight32.exe"
   $url64 = "http://dl-ak.solidworks.com/nonsecure/draftsight/$LinkVersion/DraftSight64.exe"

   return @{ 
            Version      = $PackageVersion
            URL32        = $url
            URL64        = $url64
            AppVersion   = $AppVersion
            ReleaseNotes = $ReleaseNotes
            Requirements = $Requirements
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]URL\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^[$]URL64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
        "draftsight.nuspec" = @{
            "(<Title>Draftsight).*(</Title>)"     = "`$1 $($Latest.AppVersion)`$2"
            "(<releaseNotes>).*(</releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2"
            "(Requirements]\()http.*?\)"          = "`$1$($Latest.Requirements))"
        }
    }
}

Update-Package