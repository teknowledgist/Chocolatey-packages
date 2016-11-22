$packageName='GSView'

$DownloadArgs = @{
   packageName = $packageName
   fileFullPath = (Join-Path (Join-Path $env:TEMP $packageName) GSViewInstaller.exe)
   url = 'http://pages.cs.wisc.edu/~ghost/gsview/download/gsv50w32.exe'
   url64bit = 'http://pages.cs.wisc.edu/~ghost/gsview/download/gsv50w64.exe'
   checksum = '35AFA580E02CCF0A08ECC3AEC3D7A4F1E85B8E1E862A84FDC7A3A281BAB06E3D'
   checksum64 = '80D0161ABBB3CFB0FF08F3787C4959B8A41585EF1470DAE4AEA20341820D49AF'
   checksumType = 'sha256'
}

# Download zipped install files
Get-ChocolateyWebFile @DownloadArgs

$DownloadDir = (Split-Path $DownloadArgs.fileFullPath)

# Extract zip
Get-ChocolateyUnzip $DownloadArgs.fileFullPath $DownloadDir

$InstallArgs = @{
   packageName   = $packageName
   fileType      = 'exe'
   silentArgs = "`"$env:ProgramFiles\GSView`""
   validExitCodes= @(0)
   File = (Join-Path $DownloadDir 'setup.exe')
}

Install-ChocolateyInstallPackage @InstallArgs

