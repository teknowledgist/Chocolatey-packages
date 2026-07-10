import-module chocolatey-au

function global:au_GetLatest {
   $Release = 'https://marcedit.reeset.net/software/update75.txt'
   $download_page = Invoke-WebRequest -Uri "$Release" -UseBasicParsing

   $download_page -match "^7\.[0-9]+\.[0-9]+"
   
   $version = $Matches[0]

   return @{ 
      Version = $version
      URL32 = 'https://marcedit.reeset.net/software/marcedit75/MarcEdit_7_8_mixed.exe'
   }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyinstall.ps1" = @{
         "(^\s+URL\s*=).*"      = "`${1} '$($Latest.URL32)'"
         "(^\s+Checksum\s*=).*" = "`${1} '$($Latest.Checksum32)'"
      }
   }
}

function global:au_BeforeUpdate() { 
   #   Write-Warning ("Chocolatey and AU calculate the MarcEdit checksum before it is fully downloaded.`n" +
   #   "It must be manually downloaded and checksums entered into 'VERIFICATION.txt'.")
   $toolsDir = Resolve-Path tools
   $OldInstallers = Get-ChildItem $toolsDir -filter '*.exe'
   Foreach ($exe in $OldInstallers) {Remove-Item $exe.FullName}
   
   Get-RemoteFiles -NoSuffix
   $Installer = Get-ChildItem $toolsDir -filter '*.exe' | Select-Object -ExpandProperty FullName

   $checksumExe = Join-Path "$env:ChocolateyInstall" 'tools\checksum.exe'
   
   $Latest.Checksum32 = Get-FileHash $Installer -Algorithm SHA256 |
                           Select-Object -ExpandProperty Hash
   Remove-Item $Installer -force
}

Update-Package -ChecksumFor 32