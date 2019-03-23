import-module au

$Release = 'https://marcedit.reeset.net/software/update7.txt'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $download_page -match "^7\.[0-9]+\.[0-9]+"
   
   $version = $Matches[0]
   Write-Warning ("Chocolatey and AU calculate the MarcEdit checksum before it is fully downloaded.\n" +
                  "It must be manually downloaded and checksums entered into 'VERIFICATION.txt'.")
                  
   return @{ 
      Version = $version
      URL32 = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup32Admin.msi'
      URL64 = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup64Admin.msi'
   }
}


function global:au_SearchReplace {
    @{
        "tools\VERIFICATION.txt" = @{
            "(^Version\s*: )(.*)"      = "`$1$($Latest.Version)"
            "(^x86 Checksum\s*: )(.*)" = "`$1$($Latest.Checksum32)"
            "(^x64 Checksum\s*: )(.*)" = "`$1$($Latest.Checksum64)"
        }
    }
}

Update-Package