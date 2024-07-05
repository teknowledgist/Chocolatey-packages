import-module chocolatey-au

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
         '^(\$PSEChecksum =).*'   = "`${1} '$($Latest.Checksum32)'"
         '^(\$PSEChecksum64 =).*' = "`${1} '$($Latest.Checksum64)'"
      }
   }
}

function global:au_BeforeUpdate() {
   Get-RemoteFiles -NoSuffix -Purge
   $toolsPath = Resolve-Path tools
   $ZipFile = Get-ChildItem $toolsPath -filter '*.zip'
   Expand-Archive -LiteralPath $ZipFile.FullName -DestinationPath "$env:temp\pstools_$($Latest.Version)"
   Remove-Item $ZipFile.FullName -Force
   $EXEs = Get-ChildItem "$env:temp\pstools_$($Latest.Version)" -Filter 'psexec*.exe'
   foreach ($PSEfile in $EXEs) {
      if ($PSEfile.FullName -match '64') {
         $Latest.Checksum64 = Get-FileHash $PSEfile.FullName -Algorithm SHA256 | Select-Object -ExpandProperty Hash
      } else {
         $Latest.Checksum32 = Get-FileHash $PSEfile.FullName -Algorithm SHA256 | Select-Object -ExpandProperty Hash
      }
   }
}

Update-Package -ChecksumFor none
