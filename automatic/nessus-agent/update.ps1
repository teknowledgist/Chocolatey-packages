import-module chocolatey-au

function global:au_GetLatest {
   $ReleasURL = 'https://www.tenable.com/downloads/nessus-agents'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

   $Release_page = Invoke-WebRequest -Uri $ReleasURL -UseBasicParsing

   $JSONstring = $Release_page.content.split('[]') | 
                  Where-Object {($_ -match '"version"') -and ($_ -match '\.msi')} | 
                  Select-Object -First 1
   $Agents = ConvertFrom-Json "[$JSONstring]"

   $x64agent = $Agents | Where-Object { $_.file -like '*x64.msi' }
   $ARM64agent = $Agents | Where-Object { $_.file -like '*arm64.msi' }

   $x64ID = $x64agent.id
   $ARM64ID = $ARM64agent.id

   return @{ 
      Version  = $x64agent.meta_data.version
      URL64    = "https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/$x64ID/download?i_agree_to_tenable_license_agreement=true"
      Checksum64 = $x64agent.meta_data.sha256
      URLARM64 = "https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/$ARM64ID/download?i_agree_to_tenable_license_agreement=true"
      ChecksumARM64 = $x64agent.meta_data.sha256
   }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "([$]x64url = )('.*')"       = "`$1'$($Latest.URL64)'"
         "([$]x64Checksum = )('.*')"  = "`$1'$($Latest.Checksum64)'"
         "([$]ARM64url = )('.*')"     = "`$1'$($Latest.URLARM64)'"
         "([$]ARM64Checksum = )('.*')" = "`$1'$($Latest.ChecksumARM64)'"
      }
   }
}

Update-Package -ChecksumFor none
