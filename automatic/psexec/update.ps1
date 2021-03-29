import-module au

function global:au_GetLatest {
   $InfoPage = 'https://docs.microsoft.com/en-us/sysinternals/downloads/psexec'
   $PageContent = Invoke-WebRequest -Uri $InfoPage

   $Title = $PageContent.AllElements | 
                  Where-Object {$_.tagname -eq 'h1'} |
                  Select-Object -ExpandProperty innertext
   $version = $Title.split('v')[-1]

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
