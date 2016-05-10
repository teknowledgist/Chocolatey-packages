$packageName='GSView'
$url='http://pages.cs.wisc.edu/~ghost/gsview/download/gsv50w32.exe'

If (Get-ProcessorBits -eq '64') {
   $url='http://pages.cs.wisc.edu/~ghost/gsview/download/gsv50w64.exe'
}

$WorkingDir = Join-Path $env:TEMP $packageName

$ZipPath = Join-Path $WorkingDir $url.split('/')[-1]

# Download zip
Get-ChocolateyWebFile $packageName $ZipPath $url
 
# Extract zip
Get-ChocolateyUnzip $ZipPath $WorkingDir

$InstallArgs = @{
   packageName   = $packageName
   fileType      = 'exe'
   silentArgs = "`"$env:ProgramFiles\GSView`""
   validExitCodes= @(0)
   File = (Join-Path $WorkingDir 'setup.exe')
}

Install-ChocolateyInstallPackage @InstallArgs

