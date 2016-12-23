$packageName = 'platon'

$InstallDir = 

$InstallArgs = @{
   PackageName = $packageName
   Url = 'http://www.chem.gla.ac.uk/~louis/software/platon/platon.zip' 
   UnzipLocation = $InstallDir
   checkSum = ''
   checkSumType = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs


<# 
You should also set the following environment variables to get the most out
of Platon for Windows: 
set CHECKDEF={fullpath for file CHECK.DEF e.g. c:\platgui\check.def} recommended
set RASEXE={fullpath for RasMol executable - if you have it !}
set POVEXE={fullpath for PovRAY executable - if you have it !}
set NETEXE={fullpath for NETSCAPE or other HTML browser - if you have it !}
#>
