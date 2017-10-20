$packageName = 'pydev-eclipse-java-neon'

# This avoids having to modify uninstall if the zip install file changes names
$installedZipFile = (Get-ChildItem $env:chocolateyPackageFolder -filter '*.zip.txt').name.trim('.txt')

Uninstall-ChocolateyZipPackage  $packageName $installedZipFile