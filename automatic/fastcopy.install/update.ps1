import-module au

function global:au_GetLatest {
   $RootPage = 'https://fastcopy.jp'
   $HomePage = Invoke-WebRequest -Uri "$RootPage/en/"

   $Text = $HomePage.allelements |Where-Object {
                                   ($_.tagname -eq 'th') -and 
                                   ($_.innertext -match "download v*")
                                } | Select-Object -First 1 -ExpandProperty innertext
    
   $version = $Text -replace "(?s).*v([0-9.]+).*",'$1'
   
   $Source = $HomePage.links | 
                Where-Object {$_.innertext -eq 'Source code'} | Select-Object -ExpandProperty href

<# Argh!  This site is constantly shifting!
   $x86links = $HomePage.links | 
                Where-Object {($_.innertext -eq 'installer') -and ($_.onclick -match 'fc32')} |
                Select-Object -ExpandProperty href -First 2
   Try { $DownPage = Invoke-WebRequest -Uri $x86links[0] }
   Catch { $DownPage = Invoke-WebRequest -Uri $x86links[1] }
   Finally {
      $URL32 = $DownPage.links | 
               Where-Object {$_.href -like '*.zip'} | 
               Select-Object -First 1 -ExpandProperty href
   }

   $x64links = $HomePage.links | 
                Where-Object {($_.innertext -eq 'installer') -and ($_.onclick -match 'fc64')} |
                Select-Object -ExpandProperty href -First 2
   Try { $DownPage = Invoke-WebRequest -Uri $x64links[0] }
   Catch { $DownPage = Invoke-WebRequest -Uri $x64links[1] }
   Finally { $URL64 = $DownPage.links | 
                  Where-Object {$_.href -like '*.zip'} | 
                  Select-Object -First 1 -ExpandProperty href
   }
#>
   [array]$links = $HomePage.links | 
                     Where-Object {($_.innertext -eq 'installer')} |
                     Select-Object -ExpandProperty href
   Foreach ($link in $links) {
      $DownPage = Invoke-WebRequest -Uri $link -ErrorAction SilentlyContinue
      if ($DownPage) { break }
   }
   $URL32 = $DownPage.links | 
            Where-Object {$_.href -like '*.zip'} | 
            Select-Object -First 1 -ExpandProperty href

   return @{ 
            Version   = $version
            SourceURL = "$RootPage$Source"
            URL32     = $url32
           }
}

function global:au_SearchReplace {
   @{
      "tools\VERIFICATION.txt" = @{
         "(^Version\s+:).*"   = "`${1} $($Latest.Version)"
         "(^URL\s+:).*"       = "`${1} $($Latest.URL32)"
         "(^Checksum\s+:).*"  = "`${1} $($Latest.Checksum32)"
      }
      "$($Latest.PackageName).nuspec" = @{
         "(<projectSourceUrl>).*(</projectSourceUrl>)" = "`$1$($Latest.SourceURL)`$2"
      }
   }
}

# A few things should only be done if the script is run directly (i.e. not "dot sourced")
#   (It is dot sourced in the meta-package.)
if ($MyInvocation.InvocationName -ne '.') { 
   function global:au_BeforeUpdate() { 
      Write-host "Downloading FastCopy v$($Latest.Version)"
      Get-RemoteFiles -Purge -NoSuffix
   }

   update -ChecksumFor none
   if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
