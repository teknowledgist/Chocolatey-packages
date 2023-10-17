import-module au

function isURIWeb($address) {
   $uri = $address -as [System.URI]
   $uri.AbsoluteURI -ne $null -and $uri.Scheme -match '[http|https]'
}

function global:au_GetLatest {
   $RootPage = Invoke-WebRequest -Uri 'https://fastcopy.jp' -UseBasicParsing

   $HTML = New-Object -Com "HTMLFile"
   try {
      $html.IHTMLDocument2_write($RootPage)    # if MS Office installed
   } catch {
       $html.write([Text.Encoding]::Unicode.GetBytes($RootPage))   # No MS Office
   }

   $Text = $HTML.getElementsByTagName('th') |
               Where-Object { $_.innertext -match "download v*" } | 
               Select-Object -First 1 -ExpandProperty innertext
    
   $version = $Text -replace "(?s).*v([0-9.]+).*",'$1'
   
#   $Source = $RootPage.links | 
#                Where-Object {$_.innertext -eq 'Source code'} | Select-Object -ExpandProperty href

#   [array]$links = $RootPage.links | 
#                     Where-Object {($_.innertext -eq 'installer')} |
#                     Select-Object -ExpandProperty href
#   Foreach ($link in $links) {
#      if (-not (isURIWeb $link)) {
#         if (isURIWeb "$RootPage$link") {
#            $URL32 = "$RootPage$link"
#            break
#         } else { Continue }
#      }
#      $DownPage = Invoke-WebRequest -Uri $link -ErrorAction SilentlyContinue
#      if ($DownPage) { break }
#   }
#   if ($DownPage -and (-not $URL32)) {
#      $URL32 = $DownPage.links | 
#               Where-Object {$_.href -match '\.(zip|exe)$'} | 
#               Select-Object -First 1 -ExpandProperty href
#   }

$URL32 = 'https://github.com/FastCopyLab/FastCopyDist2/raw/main/FastCopy5.0.5_installer.exe'
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
   }
}

update -ChecksumFor 32
