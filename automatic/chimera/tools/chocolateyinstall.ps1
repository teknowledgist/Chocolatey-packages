$ErrorActionPreference = 'Stop'

$AppVersion = '1.16'

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
   checksum64    = '3557fbf14c90bf8368650a1fe934ff44e050e11feb510022b4e075d32f6b00b3'
   checksumType64= 'sha256'
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
