import-module chocolatey-au

function global:au_GetLatest {
   $RootPage = Invoke-WebRequest -Uri 'https://fastcopy.jp' -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($RootPage.rawcontent)    # if MS Office installed
   } catch {
       $html.write([Text.Encoding]::Unicode.GetBytes($RootPage))   # No MS Office
   }

   $Text = $HTML.getElementsByTagName('th') |
               Where-Object { $_.innertext -match "download v*" } | 
               Select-Object -First 1 -ExpandProperty innertext
    
   $version = $Text -replace "(?s).*v([0-9.]+).*",'$1'
   
   $URL32 = "https://raw.githubusercontent.com/FastCopyLab/FastCopyDist2/main/FastCopy$($version)_installer.exe"

   return @{ 
            Version   = $version
            URL32     = $url32
           }
}

function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^\s+URL\s+=).*"       = "`${1} '$($Latest.URL32)'"
         "(^\s+Checksum\s+=).*"  = "`${1} '$($Latest.Checksum32)'"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   update -ChecksumFor 32
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
