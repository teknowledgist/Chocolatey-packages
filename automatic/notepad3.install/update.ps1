import-module au

function global:au_GetLatest {
   $ReleaseURL = 'https://github.com/rizonesoft/Notepad3/releases/latest'
   [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
   $download_page = Invoke-WebRequest -Uri $ReleaseURL -UseBasicParsing

   $Release = $download_page.rawcontent.split('<|>') |
                 Where-Object {$_ -match 'release ([0-9.]+)'} | Select-Object -first 1

   $Version = $Matches[1]
   
   $DownloadURL = 'https://www.rizonesoft.com/downloads/notepad3/'
   $download_page = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
   $Stubs = $download_page.Links | Where-Object {($_.title -match $Version) -and ($_.outerhtml -match 'setup')}

   $url64 = $Stubs | Where-Object {$_.outerHTML -notmatch 'x86'} | Select-Object -ExpandProperty href
   $url32 = $Stubs | Where-Object {$_.outerHTML -match 'x86'} | Select-Object -ExpandProperty href

   return @{ 
            Version  = $Version
            URL64    = $url64
            URL32    = $url32
            FileType = 'zip'
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
      $FileBase = "Notepad3_$($Latest.Version)_Setup"
      Get-RemoteFiles -Purge -FileNameBase $FileBase -FileNameSkip 2
   }

   update -ChecksumFor none -NoCheckChocoVersion
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
