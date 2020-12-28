$ErrorActionPreference = 'Stop'

$BaseURL = 'https://www.cgl.ucsf.edu'

# Discovering download link
# Process found here:  https://stackoverflow.com/questions/34422255/
# Unsure if all settings are needed.
$url = "$BaseURL/chimera/cgi-bin/secure/chimera-get.py"
$postData = "choice=Accept&file=win64/chimera-$env:ChocolateyPackageVersion-win64.exe"
$buffer = [text.encoding]::ascii.getbytes($postData)
[net.httpWebRequest] $req = [net.webRequest]::create($url)
$req.method = "POST"
$req.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
$req.Headers.Add("Accept-Language: en-US")
$req.Headers.Add("Accept-Encoding: gzip,deflate")
$req.Headers.Add("Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7")
$req.AllowAutoRedirect = $false
$req.ContentType = "application/x-www-form-urlencoded"
$req.ContentLength = $buffer.length
$req.TimeOut = 50000
$req.KeepAlive = $true
$req.Headers.Add("Keep-Alive: 300");
$reqst = $req.getRequestStream()
$reqst.write($buffer, 0, $buffer.length)
$reqst.flush()
$reqst.close()
[net.httpWebResponse] $res = $req.getResponse()
$resst = $res.getResponseStream()
$sr = new-object IO.StreamReader($resst)
$result = $sr.ReadToEnd()
$res.close()

$URLstub = ($result.split() |? {$_ -match 'href='}) -replace '.*href="(.*)".*','$1'

Write-Host 'You are establishing a license agreement as defined here:' -ForegroundColor Cyan
Write-Host 'http://www.cgl.ucsf.edu/chimera/license.html' -ForegroundColor Cyan

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = $BaseURL + $URLstub
   softwareName  = 'UCSF Chimera*' 
   checksum64    = '98a7f234bb99c22448fb82767ead4ef76e7cb039a87d89f6d752dcf7379914ce'
   checksumType64= 'sha256'
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
