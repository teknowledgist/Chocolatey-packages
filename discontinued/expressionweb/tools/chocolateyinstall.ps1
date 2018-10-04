$ErrorActionPreference = 'Stop'

$pp = Get-PackageParameters

switch ($pp['Lang']) {
   'de' { 
      $URL = 'http://download.microsoft.com/download/4/C/D/4CD17612-4DD7-4968-9B2B-26D68CFB1A63/Web_Trial_de.exe'
      $Checksum = '886c7f72b17ac0de598335679020b1d0040501ac4e7d2721d8d59a1ce8628b9c' }
   'es' { 
      $URL = 'http://download.microsoft.com/download/E/D/F/EDF72C01-578E-40A2-9502-9C15F70EC524/Web_Trial_es.exe'
      $Checksum = '93ee45a1a57a4715fc4801d7629817be5d0f1b878690535ef23eaad6c3034944' }
   'fr' { 
      $URL = 'http://download.microsoft.com/download/3/A/E/3AEA9622-43FF-4806-9918-36C367C26AFF/Web_Trial_fr.exe'
      $Checksum = '8043ecbcc5ad7076fd03c0218897ba8c7259c3d18e58c99c65b930ff3c7597cb' }
   'it' { 
      $URL = 'http://download.microsoft.com/download/9/B/E/9BEDC17B-52BE-40A7-96B2-54E4E7E76905/Web_Trial_it.exe'
      $Checksum = 'cda91e749c1c490a15cb61ee71e248238adaa112852bf64ab2ffd4123926b843' }
   'ja' { 
      $URL = 'http://download.microsoft.com/download/8/3/2/8326FD52-3C69-4BD5-BE8C-EB509A5ACB7A/Web_Trial_ja.exe'
      $Checksum = 'c058823e1eb55bf266c247c0fd2a6e6886ee2d9967b1280c96deb27a77421074' }
   'ko' { 
      $URL = 'http://download.microsoft.com/download/1/0/2/1028A09D-3DE8-477A-96BD-5BE562E2C925/Web_Trial_ko.exe'
      $Checksum = '3c19e0b9cf4d2754ee8bc97d5f6712778de8d5f2f89b6807ad9317a7151e2c90' }
   'zhs' { 
      $URL = 'http://download.microsoft.com/download/E/D/C/EDC7D9A2-5649-49CB-B0D0-C13CF607454F/Web_Trial_zh-Hans.exe'
      $Checksum = '56d184a012a71fca0cd15ce2d15f62864543f26ab91dd1d9aa9e51f968c54a39' }
   'zht' { 
      $URL = 'http://download.microsoft.com/download/2/B/E/2BE7AA64-07FA-4E37-99CD-BC9722691FB7/Web_Trial_zh-Hant.exe'
      $Checksum = '9249c204a84d3d28df2dd0a6ef7707bf726172bbf2cca3d1c6abff3c83bb43b2' }
   default { 
      $URL = 'https://download.microsoft.com/download/F/D/8/FD88D81D-52B5-486A-A53F-CCDB485D5258/Web_Trial_en.exe'
      $Checksum = 'edd13893bcff2267b3f9bb257208b8d20325db958a995abbfe5fb1fedd864194' }
}

$packageArgs = @{
   PackageName   = $env:ChocolateyPackageName
   FileType      = 'exe'
   Url           = $URL
   Checksum      = $Checksum
   ChecksumType  = 'sha256'
   SilentArgs    = "-q -l*v:`"$($env:TEMP)\$($env:ChocolateyPackageName).Install.log`""
   ValidExitCodes= @(0,3010,-2146233087,2359302)
}
Install-ChocolateyPackage @packageArgs
