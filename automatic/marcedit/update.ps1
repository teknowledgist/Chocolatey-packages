import-module au

$Release = 'https://marcedit.reeset.net/software/update7.txt'

function global:au_GetLatest {
   $download_page = Invoke-WebRequest -Uri "$Release"

   $download_page -match "^7\.[0-9]+\.[0-9]+"
   
   $version = $Matches[0]

   return @{ 
      Version = $version
      URL32 = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup32Admin.msi'
      URL64 = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup64Admin.msi'
   }
}


function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s*:)(.*)"    = "`$1 $($Latest.Version)"
         "(^x86 SHA256\s*:)(.*)" = "`$1 $($Latest.Checksum32)"
         "(^x64 SHA256\s*:)(.*)" = "`$1 $($Latest.Checksum64)"
      }
   }
}

function global:au_BeforeUpdate() { 
   #   Write-Warning ("Chocolatey and AU calculate the MarcEdit checksum before it is fully downloaded.`n" +
   #   "It must be manually downloaded and checksums entered into 'VERIFICATION.txt'.")
   $toolsDir = Resolve-Path tools
   $OldInstallers = Get-ChildItem $toolsDir -filter '*.msi'
   Foreach ($msi in $OldInstallers) {Remove-Item $msi.FullName}
   
   Get-RemoteFiles -NoSuffix
   $Installers = Get-ChildItem $toolsDir -filter '*.msi'

   $checksumExe = Join-Path "$env:ChocolateyInstall" 'tools\checksum.exe'
   
   $Latest.Checksum32 = Get-FileHash $(($Installers | 
                           Where-Object {$_.basename -match '32'}).FullName) -Algorithm SHA256 | 
                           Select-Object -ExpandProperty Hash
   $Latest.Checksum64 = Get-FileHash $(($Installers | 
                           Where-Object {$_.basename -match '64'}).FullName) -Algorithm SHA256 |
                           Select-Object -ExpandProperty Hash
}

Update-Package -ChecksumFor none