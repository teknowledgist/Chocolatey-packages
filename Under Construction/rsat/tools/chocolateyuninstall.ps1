#Requires -RunAsAdministrator

$package = 'RSAT'
$osInfo = Get-WmiObject Win32_OperatingSystem | SELECT Version, ProductType, Caption
$osInfo.Version = [version] $osInfo.Version

if ($osInfo.Version -lt [version]'6.0') {
    Write-Host 'The Remote System Administration Tool (RSAT) requires Windows Vista, Windows 2008 Server or later.'
    return
}
elseif ($osInfo.ProductType -ne 1) {
    Write-Host 'The RSAT is built into Windows server OSes, making this effectively a stub package'
}
else {
    if ($osInfo.Version.Major -eq 6) {
        if ($osInfo.Version.Minor -eq 0) { #Windows Vista
        }
        elseif ($osInfo.Version.Minor -eq 1) { #Windows 7
        }
        elseif ($osInfo.Version.Minor -eq 2) { #Windows 8
        }
		elseif ($osInfo.Version.Minor -eq 3) { #Windows 8.1
        }
		dism /online /get-features | Select-String -Pattern remote* | %{$Exec = "dism.exe /online /disable-feature /featurename:RemoteServerAdministrationTools /featurename:" + ($_).ToString().Replace('Feature Name : ',''); Invoke-expression $Exec}
    }elseif ($osInfo.Version.Major -eq 10) {
        if ($osInfo.Version.Minor -eq 0) { #Windows 10
        }
		dism /online /get-features | Select-String -Pattern rsat* | %{$Exec = "dism.exe /online /disable-feature /featurename:RSATClient /featurename:" + ($_).ToString().Replace('Feature Name : ',''); Invoke-expression $Exec}
    }
}
