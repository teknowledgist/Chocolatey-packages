$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'exe'
   url           = 'https://download01.logi.com/web/ftp/pub/techsupport/capture/Capture_1.0.553.exe'
   checksum      = '4327ee44b6c03850ad35164505fd9a5f4cd20a1242bcd36ca03a21972f1ae687'
   checksumType  = 'sha256'
   silentArgs    = "/S"
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs 
