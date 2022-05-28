import-module au

function global:au_GetLatest {
   $InfoPage = 'https://docs.microsoft.com/en-us/sysinternals/downloads/psexec'
   $PageContent = Invoke-WebRequest -Uri $InfoPage

   $H1 = $PageContent.content -split "</?h1" | ? { $_ -match '\>psexec v'}
   
   $version = $H1.split('v')[-1]

   $URL32 = 'https://download.sysinternals.com/files/PSTools.zip'

   return @{ 
         Version = $version
         URL32   = $URL32
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyinstall.ps1" = @{
         "(^\`$Checksum =).*" = "`${1} '$($Latest.Checksum32)'"
      }
   }
}

Update-Package
