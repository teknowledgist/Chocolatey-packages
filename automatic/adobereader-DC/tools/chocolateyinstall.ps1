# adobe-acrobat-reader-dc install

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlPackageEXE       = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1900820071/AcroRdrDC1900820071_MUI.exe'
$urlPackageMSP       = 'http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1900820081/AcroRdrDCUpd1900820081_MUI.msp'
$checksumPackageEXE  = '0fea79f1fe7fa407846e6253c10f8739cbb6532b7181a7f8d3c2538ead8d6fbb97faa72334df7d2af9e058d1b15c7ced5e57a36733cf8678de959081cbbd0727'
$checksumPackageMSP  = '90D5B0101F17918B2EC36ABB40ED1F04703E46101513EFDDB51D5E3CB73519950434440149700CCD737DCB4B1FAEFEFE4D4707C46BC9C96FE5BA7A6C4365B8D3'
$checksumTypePackage = 'SHA512'
$binDir              = "$($toolsDir)\bin"
$mspPath             = Join-Path $binDir "AcroRdrDCUpd$($env:ChocolateyPackageVersion).msp"

Import-Module -Name "$($toolsDir)\helpers.ps1"

$packageArgsEXE = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = $urlPackageEXE
    checksum       = $checksumPackageEXE
    checksumType   = $checksumTypePackage
	silentArgs     = '/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES'
    validExitCodes = @(0, 1000, 1101)
}

#if (-Not (Get-ProductName("Adobe Acrobat Reader DC MUI"))) {
    Install-ChocolateyPackage @packageArgsEXE
#}

$args = "/p $mspPath /quiet"
Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath $mspPath -Url $urlPackageMSP -Checksum $checksumPackageMSP -ChecksumType $checksumTypePackage
Start-ChocolateyProcessAsAdmin $args 'msiexec'

if ($PackageParameters.RemoveDesktopIcons) {
    Remove-DesktopIcons -Name "Acrobat Reader DC" -Desktop "Public"
}

if ($PackageParameters.EnableAutoUpdate) {
    SchTasks /Change /Enable /TN "Adobe Acrobat Update Task" | Out-Null
    Set-Service "AdobeARMservice" -StartupType Automatic | Out-Null
    Start-Service "AdobeARMservice" | Out-Null
    Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" `
        -Name "bUpdater" `
        -Type DWORD `
        -Value 1 `
        -Message "Enable Update Button"
} else {
    Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" `
        -Name "bUpdater" `
        -Type DWORD `
        -Value 0 `
        -Message "Disable Update Button"    
    SchTasks /Change /Disable /TN "Adobe Acrobat Update Task" | Out-Null
    Stop-Service "AdobeARMservice" -force | Out-Null
    Set-Service "AdobeARMservice" -StartupType Disabled | Out-Null
}
