$ErrorActionPreference = 'Stop'

$ModuleName = $env:ChocolateyPackageName.replace('.powershell','')
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipFile = (Get-ChildItem -Path $toolsDir -filter '*.zip' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

# module may already be installed outside of Chocolatey and "active", so disable it
Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

# remove previous version installations (by this package) before installing a new one
$TrackInstalls = Join-Path $toolsDir -ChildPath 'installations.saved'
if (Test-Path -Path $TrackInstalls) {
   $removePath = Get-Content -Path $TrackInstalls
   ForEach ($path in $removePath) {
      Write-Verbose "Removing previous version of '$ModuleName' from '$path'."
      Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
   }
   Remove-Item -Path $TrackInstalls -Force
}

# Prepare to install for Core if installed and for desktop/legacy if running it
$destinationPaths = @()
$destinationStub = "PowerShell\Modules\$ModuleName\$env:ChocolateyPackageVersion"
$CoreInstalled = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | 
                     Where-Object {$_.DisplayName -match 'PowerShell [^345]' }
if ($CoreInstalled) {
   $destinationPaths += Join-Path -Path $env:ProgramFiles -ChildPath $destinationStub
}
if ($PSVersionTable.PSEdition -eq 'desktop') {
   $destinationPaths += Join-Path -Path $env:ProgramFiles -ChildPath "Windows$destinationStub"
}

ForEach ($destPath in $destinationPaths) {
    Write-Verbose "Installing '$ModuleName' to '$destPath'."

    # check destination path exists and create if not
    if (Test-Path -Path $destPath) {
        $null = New-Item -Path $destPath -ItemType Directory -Force
    }
    Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $destPath -PackageName $env:ChocolateyPackageName

    # save install locations so uninstalls will only affect what we've installed
    Add-Content -Path $TrackInstalls -Value $destPath
}

Remove-Item -Path $ZipFile -Force -Recurse