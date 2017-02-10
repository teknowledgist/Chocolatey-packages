$packageName = 'DraftSight'
$version = '2017SP0'

# https://www.3ds.com/products-services/draftsight-cad-software/free-download/

$InstallArgs = @{
   packageName = $packageName
   installerType = 'exe'
   url = "https://dl-ak.solidworks.com/nonsecure/draftsight/2017SP0/DraftSight32.exe"
   url64 = "http://dl-ak.solidworks.com/nonsecure/draftsight/$version/DraftSight64.exe"
   checkSum = ''
   checkSumType = 'sha256'
   silentArgs = '/s /v"/qn"'
   validExitCodes = @(0,3010)
}

Install-ChocolateyPackage @InstallArgs


# Critical Hotfix:  http://dl-ak.solidworks.com/nonsecure/draftsight/HOTFIX-2017SP0-V1R3/DraftSight_HotFix_2017.exe