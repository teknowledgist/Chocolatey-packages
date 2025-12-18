import-module chocolatey-au

function global:au_GetLatest {
   $DUrl = 'https://solutions.teamdynamix.com/TDClient/1965/Portal/KB/ArticleDet?ID=169236'
   $download_page = Invoke-WebRequest -Uri "$DUrl"

   $VersionString = $download_page.AllElements | 
         Where-Object {$_.tagname -eq 'p' -and $_.innertext -match 'Minor Version'}|
         Select -exp innerText
   $Version = $VersionString -replace '[^0-9.]',''
   
   $SHA64 = ($download_page.AllElements | 
               Where-Object { $_.tagname -eq 'a' -and $_.innertext -match 'client-x64\.exe' } |
               Select-Object -ExpandProperty innerText).split(' ') | 
               Where-Object { $_.length -eq 64 }
   
   $SHA86 = ($download_page.AllElements | 
         Where-Object { $_.tagname -eq 'a' -and $_.innertext -match 'client-i386\.exe' } |
         Select-Object -ExpandProperty innerText).split(' ') | 
         Where-Object { $_.length -eq 64 }

   return @{ 
      Version = $Version
      Checksum32 = $SHA86
      checksum64 = $SHA64
   }
}

function global:au_SearchReplace {
    @{
       "tools\chocolateyInstall.ps1" = @{
          "(^\s*Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
          "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
       }
    }
}

Update-Package -ChecksumFor none
