import-module au

$FilesPage = 'https://sourceforge.net/projects/openchrom/files/'
<#
There are versioning timestamps here:  https://github.com/OpenChrom/openchrom/wiki/changelog
Also, that timestamp seems to match the "executable.win32.win32.x86_64" binary artifact in
   the ".\p2\org.eclipse.equinox.p2.core\cache\artifacts.xml" file of the downloadable zip.
#>
function global:au_GetLatest {
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $download_page = Invoke-WebRequest -Uri $FilesPage

   $stub = ($download_page.links |
                 Where-Object {$_.href -match 'latest'} | 
                 Select-Object -ExpandProperty title).split(':')[0]

   $Null = $stub.split('/') | ? {$_ -match '^REL-([0-9.]+)$'}
   $Version = $Matches[1]

   $url = $FilesPage + $stub

   return @{ 
            Version    = $Version
            URL32      = $url
           }
}

function global:au_SearchReplace {
    @{
      "tools\chocolateyInstall.ps1" = @{
         "(^\s+URL\s*=\s*)('.*')"      = "`${1}'$($Latest.URL32)'"
         "(^\s+Checksum\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum32)'"
      }
    }
}


update -ChecksumFor all