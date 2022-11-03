import-module au

function global:au_GetLatest {
   $Release = 'https://www.xnview.com/en/xnviewmp/'
   $download_page = Invoke-WebRequest -Uri $Release

   $URLs = $download_page.links |
               Where-Object {$_.href -match '\.zip'} |
               Select-Object -First 2 -ExpandProperty href

   $VersionText = $download_page.AllElements | 
                     Where-Object {$_.class -eq 'h5 fw-bold'} | 
                     Select-Object -First 1 -ExpandProperty innertext

   return @{ 
            Version = $VersionText.split()[0]
            URL32   = $URLs | Where-Object {$_ -notmatch 'x64'}
            URL64   = $URLs | Where-Object {$_ -match 'x64'}
           }
}


function global:au_SearchReplace {
    @{
      'legal\VERIFICATION.md' = @{
         '(- Version\s+:).*'    = "`${1} $($Latest.Version)"
         '(- x86 URL\s+:).*'    = "`${1} $($Latest.URL32)"
         '(- x86 SHA256\s+:).*' = "`${1} $($Latest.Checksum32)"
         '(- x64 URL\s+:).*'    = "`${1} $($Latest.URL64)"
         '(- x64 SHA256\s+:).*' = "`${1} $($Latest.Checksum64)"
      }
    }
}

function global:au_BeforeUpdate() { 
   Write-host "Downloading XnView MP $($Latest.Version) zip files"
   Get-RemoteFiles -Purge -NoSuffix
}

update -ChecksumFor none 
