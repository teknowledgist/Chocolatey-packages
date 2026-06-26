import-module chocolatey-au

function global:au_GetLatest {
   $Olex2Page = 'https://www.olexsys.org/olex2/docs/getting-started/installing-olex2/'
   $pagecontent = iwr -uri $Olex2Page -UseBasicParsing

   $linkstring = $pagecontent.RawContent.split('<>') | 
                  Where-Object {$_ -match 'win64\.zip$' -and $_ -notmatch '(beta|alpha)'} | 
                  Select-Object -first 1
   $version = $linkstring.split('/') | Where-Object {$_ -match '^[0-9.]+$'}

   $url64 = "http://www2.olex2.org/olex2-distro/$version/olex2-win64.zip"

   return @{ 
            Version = $version
            URL64   = $url64
           }
}


function global:au_SearchReplace {
    @{
      "tools\chocolateyInstall.ps1" = @{
         "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
         "(^[$]checkSum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package