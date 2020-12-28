import-module au

function global:au_GetLatest {
   $Release = 'https://github.com/rizonesoft/Notepad3/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $Release -UseBasicParsing

   $urlstub = $download_page.rawcontent.split('"') | 
                Where-Object {$_ -match '\.zip'} | Select-Object -First 1

   $Version = $urlstub -replace ".*Notepad3_([0-9.]+)\.zip",'$1'
   
   $url64 = "https://www.rizonesoft.com/software/notepad3/Notepad3_$($Version)_Setup.zip"
   $url32 = "https://www.rizonesoft.com/software/notepad3/Notepad3_$($Version)_x86_Setup.zip"

   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^x86 URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^x86 Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
         "(^x64 URL\s+:).*"          = "`${1} $($Latest.URL64)"
         "(^x64 Checksum\s+:).*"     = "`${1} $($Latest.Checksum64)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Notepad3 $($Latest.Version) files."
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none -NoCheckChocoVersion
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
