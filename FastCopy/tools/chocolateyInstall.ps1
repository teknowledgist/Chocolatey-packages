$packageName = 'fastcopy'

$url='http://ftp.vector.co.jp/66/88/2323/FastCopy313.zip'

If (Get-ProcessorBits -eq '64') {
   $url='http://ftp.vector.co.jp/66/88/2323/FastCopy313_x64.zip'
}

$WorkingDir = Join-Path $env:TEMP $packageName
$ZipPath = Join-Path $WorkingDir $url.split('/')[-1]

# Download zip
Get-ChocolateyWebFile $packageName $ZipPath $url
 
# Extract zip
Get-ChocolateyUnzip $ZipPath $WorkingDir

$InstallArgs = @{
   packageName = $packageName
   fileType      = 'exe'
   silentArgs = ''
   File = (Join-Path $WorkingDir 'setup.exe')
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Definition

# Win7 complains the installer didn't run correctly.  This will prevent that.
Set-Variable __COMPAT_LAYER=!Vista

& AutoHotKey $(Join-Path $ScriptDir 'chocolateyInstall.ahk')
& $(Join-Path (Split-Path $ZipPath) 'setup.exe')

