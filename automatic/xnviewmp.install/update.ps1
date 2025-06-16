import-module chocolatey-au

function global:au_GetLatest {
   $DownMPurl = 'https://www.xnview.com/en/xnview-mp/'
   $Downpage = Invoke-WebRequest -Uri $DownMPurl -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($Downpage.rawcontent)    # if MS Office installed
   } catch {
      $html.write([Text.Encoding]::Unicode.GetBytes($Downpage))   # No MS Office
   }
   
   $VersionText = $HTML.getElementsByTagName('strong') |
                     Where-Object {$_.innertext -match 'XnView MP'} | 
                     Select-Object -ExpandProperty innertext -First 1
   $Version = $VersionText.split() | Where-Object {$_ -match '^[0-9.]+$'}

   $DownStub = $HTML.links |
               Where-Object {$_.href -match 'x64\.exe'} |
               Select-Object -First 1 -ExpandProperty nameprop
   $URL = "https://www.xnview.com/$DownStub"

   return @{ 
            Version = $Version
            URL64   = $URL
           }
}


function global:au_SearchReplace {
    @{
      'legal\VERIFICATION.md' = @{
         '(- Version\s+:).*'    = "`${1} $($Latest.Version)"
         '(- x64 URL\s+:).*'    = "`${1} $($Latest.URL64)"
         '(- x64 SHA256\s+:).*' = "`${1} $($Latest.Checksum64)"
      }
    }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
      Write-host "Downloading XnView MP $($Latest.Version) installer file"
      Get-RemoteFiles -Purge -NoSuffix -FileNameBase 'XnViewMP-win-x64'
   }

   update -ChecksumFor none 
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
