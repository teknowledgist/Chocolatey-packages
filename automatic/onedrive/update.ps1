import-module au

function global:au_GetLatest {
   $Release = 'https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0'
   
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $vstrings = $download_page.RawContent -split ">|<" | 
                     Where-Object {$_ -match '^Version'} | 
                     Select-Object -first 1
   $Version = $vstrings.split()[1]

   return @{ 
      Version = $Version
      URL32   = "https://oneclient.sfx.ms/Win/Installers/$Version/amd64/OneDriveSetup.exe"
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
         "(^   Checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      }
   }
}

Update-Package -nocheckchocoversion
