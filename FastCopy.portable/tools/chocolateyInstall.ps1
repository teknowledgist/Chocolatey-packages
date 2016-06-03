$Arguments = @{
   packageName = 'fastcopy.portable'
   url='http://ftp.vector.co.jp/66/88/2323/FastCopy313.zip'
   url64='http://ftp.vector.co.jp/66/88/2323/FastCopy313_x64.zip'
   unzipLocation = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
}
New-Item (Join-Path $Arguments.unzipLocation 'FastCopy.exe.gui') -ItemType file -Force | Out-Null
New-Item (Join-Path $Arguments.unzipLocation 'setup.exe.ignore') -ItemType file -Force | Out-Null

Install-ChocolateyZipPackage @Arguments
