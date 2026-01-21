import-module chocolatey-au

function global:au_GetLatest {
   $DUrl = 'https://solutions.teamdynamix.com/TDClient/1965/Portal/KB/ArticleDet?ID=169236'
   $download_page = Invoke-WebRequest -Uri "$DUrl" -UseBasicParsing

   $VersionString = $download_page.rawcontent -split '<\/?p' | 
         Where-Object {$_ -match 'Minor Version'}
   $Version = ($VersionString -replace '.*([^0-9.])','$1').trim()
   
   $SHA64 = (($download_page.rawcontent -split '<\/?a' | 
               Where-Object {$_ -match 'client-x64\.exe' }) -split '[<>]' | 
               Where-Object {$_ -match 'sha256'}) -split '(\s|&nbsp;)' |
               Where-Object {$_.length -eq 64}

   $SHA86 = (($download_page.rawcontent -split '<\/?a' | 
               Where-Object {$_ -match 'client-i386\.exe' }) -split '[<>]' | 
               Where-Object {$_ -match 'sha256'}) -split '(\s|&nbsp;)' |
               Where-Object {$_.length -eq 64}

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
