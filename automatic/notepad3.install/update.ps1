import-module au

function global:au_GetLatest {
   $Repo = 'https://github.com/rizonesoft/Notepad3'
   $Release = Get-LatestReleaseOnGitHub -URL $Repo

   $version = ($Release.Tag -replace '.*?([0-9.]+).*','$1').trim('.')
   $URL32 = $Release.Assets | 
               Where-Object {$_.FileName -match 'x86_Setup\.exe'} | 
               Select-Object -First 1 -ExpandProperty DownloadURL
   $URL64 = $Release.Assets | 
               Where-Object {($_.FileName -match 'Setup\.exe') -and ($_.FileName -notmatch 'x86')} | 
               Select-Object -First 1 -ExpandProperty DownloadURL
   
   $DownloadURL = 'https://www.rizonesoft.com/downloads/notepad3/'
   try { 
      $download_page = Invoke-WebRequest -Uri $DownloadURL
      $linkLines = $download_page.rawcontent -split 'tr><' | ? {$_ -match $version.replace('.','\.')} | select -First 2
      $URL64 = $linkLines[0] -split '"' | ? {$_ -match '^https'} | select -first 1
      $URL32 = $linkLines[1] -split '"' | ? {$_ -match '^https'} | select -first 1
   }
   catch {}
   if (-not ($url64 -and $URL32)) {
      Throw 'Notepad3 download URLs not usable'
   }

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
