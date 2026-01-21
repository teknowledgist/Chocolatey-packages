import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'http://www.intusoft.com/demos.php'
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $link = $download_page.links | ? {$_.href -like '*ICAP4Demo.zip'}

   $url = "http://www.intusoft.com/demos/ICAP4Demo.zip"

   $Versiontext = $link.outerHTML -replace '(?s).*\sV([0-9x.]+)\sBuild\s(\d+)<.*','$1.$2'

   # It's not clear why they use "X" for the minor version.  
   #   With build 4444, x=3.  Might change in the future.  
   $Version = $Versiontext -replace 'x','3'

   return @{ 
            Version    = $Version
            URL32      = $url
           }
}


function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]URL\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(^[$]Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
        "tools\ICAP4setup.iss" = @{
            "^(Name=.*Build).*"            = "`$1 $(([version]$Latest.Version).Revision)"
            "^(Version=8\.00)\..*"          = "`$1.$(([version]$Latest.Version).Revision)"
        }
        "tools\ICAP4remove.iss" = @{
            "^(Name=.*Build).*"            = "`$1 $(([version]$Latest.Version).Revision)"
            "^(Version=8\.00)\..*"          = "`$1.$(([version]$Latest.Version).Revision)"
        }
        "tools\ICAP4remove2.iss" = @{
            "^(Name=.*Build).*"            = "`$1 $(([version]$Latest.Version).Revision)"
            "^(Version=8\.00)\..*"          = "`$1.$(([version]$Latest.Version).Revision)"
        }
    }
}

Update-Package -ChecksumFor 32