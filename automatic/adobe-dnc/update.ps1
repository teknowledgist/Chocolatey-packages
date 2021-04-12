import-module au

function global:au_GetLatest {
   $FTPFolder = 'ftp://ftp.adobe.com/pub/adobe/dng/win/'

   $FTPRequest = [System.Net.FtpWebRequest]::Create($FTPFolder)
   $FTPRequest.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory
   $FTPRequest.UseBinary = $False
   $FTPRequest.KeepAlive = $False
   $ResponseStream = $FTPRequest.GetResponse().GetResponseStream()
   $StreamReader = New-Object System.IO.Streamreader $ResponseStream
   $fileList = (($StreamReader.ReadToEnd()) -split [Environment]::NewLine)
   $StreamReader.Close()

   $Version = [version]'0.0'
   foreach ($file in ($fileList | ? {$_ -match '^DNGConverter_[0-9_]+\.exe'})) {
      $VersionString = $file -replace '.*?_([0-9_]+)\.exe','$1'
      [version]$FileVersion = $VersionString.replace('_','.')
      if ($FileVersion -gt $Version) {
         $Version = $FileVersion
         $FileName = $file
      }
   }

   $url64 = "$FTPFolder$FileName"

   return @{ 
            Version      = $version.ToString()
            URL64        = $url64
         }
}


function global:au_SearchReplace {
   @{
      "tools\chocolateyInstall.ps1" = @{
         "(^   url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
         "(^   Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
      }
   }
}


update -ChecksumFor 64
