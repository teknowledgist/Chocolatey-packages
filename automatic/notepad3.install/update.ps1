import-module au

function global:au_GetLatest {
   $Release = 'https://raw.githubusercontent.com/rizonesoft/Notepad3/master/src/VersionEx.h'
   $VersionText = Invoke-WebRequest -Uri $Release

   $major    = ($VersionText.content.split("`n") | ? { $_ -match ".*MAJOR (\d+)"}).split()[-1]
   $minor    = ($VersionText.content.split("`n") | ? { $_ -match ".*MINOR (\d+)"}).split()[-1]
   $revision = ($VersionText.content.split("`n") | ? { $_ -match ".*REV (\d+)"}).split()[-1]
   $Build    = ($VersionText.content.split("`n") | ? { $_ -match ".*BUILD (\d+)"}).split()[-1]
   $Version = "$major.$minor.$revision.$build"
   
   $HomeURL = 'https://www.rizonesoft.com/downloads/notepad3/'
   $DownloadPage = Invoke-WebRequest -Uri $HomeURL
   $DownloadLink = $DownloadPage.Links |? {$_.innertext -match 'replace Windows Notepad'}
   $DownloadURL = $DownloadLink.href
   
   return @{ 
            Version  = $Version
            URL32    = $DownloadURL
            FileType = 'exe'
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"      = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"          = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"     = "`${1} $($Latest.Checksum32)"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
   Write-host "Downloading Notepad3_x_$($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase "Notepad3_x_$($Latest.Version)" 
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
