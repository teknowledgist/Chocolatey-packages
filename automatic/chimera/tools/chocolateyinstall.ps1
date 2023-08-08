$ErrorActionPreference = 'Stop'

$AppVersion = '1.17.3'

$BaseURL = 'https://www.cgl.ucsf.edu'

# Discovering download link
$url = "$BaseURL/chimera/cgi-bin/secure/chimera-get.py"
$PostParams = @{
   choice='Accept'
   file="win64/chimera-$AppVersion-win64.exe"
}
$DownloadPage = Invoke-WebRequest $url -method Post -Body $postparams -UseBasicParsing

$URLstub = ($DownloadPage.content.split() | Where-Object {$_ -match 'href='}) -replace '.*href="(.*)".*','$1'

Write-Host 'You are establishing a license agreement as defined here:' -ForegroundColor Cyan
Write-Host 'http://www.cgl.ucsf.edu/chimera/license.html' -ForegroundColor Cyan

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = $BaseURL + $URLstub
   softwareName  = 'UCSF Chimera*' 
   checksum64    = '9b5420731f2149e0881d33ed62d6ebb445f225779574a120b18ed3b42f36cd35'
   checksumType64= 'sha256'
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
