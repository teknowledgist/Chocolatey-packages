#Requires -RunAsAdministrator

#	Source : Drew Robinson, XENOPHANE, Felix Benoit

$packageName = 'RSAT'
$osInfo = Get-WmiObject Win32_OperatingSystem | SELECT Version, ProductType, Caption
$osInfo.Version = [version] $osInfo.Version

if ($osInfo.Version -lt [version]'6.0') {
    Write-Host 'The Remote System Administration Tool (RSAT) requires Windows Vista or later.'
    return
}
elseif ($osInfo.ProductType -ne 1) {
    Write-Host 'The RSAT is built into Windows server OSes, making this effectively a stub package'
}
else {
	$Lang=[System.Globalization.Cultureinfo]::CurrentCulture
	$Lang=$Lang.Name.ToLower()
    if ($osInfo.Version.Major -eq 6) {
        if ($osInfo.Version.Minor -eq 0) { #Windows Vista
			Write-host 'Vista Detected' -foregroundcolor yellow
			$web = Invoke-WebRequest https://www.microsoft.com/$Lang/download/confirmation.aspx?id=21090 -UseBasicParsing
        }
        elseif ($osInfo.Version.Minor -eq 1) { #Windows 7
			Write-host 'Windows 7 Detected' -foregroundcolor yellow
			$web = Invoke-WebRequest https://www.microsoft.com/$Lang/download/confirmation.aspx?id=7887 -UseBasicParsing
        }
        elseif ($osInfo.Version.Minor -eq 2) { #Windows 8
			Write-host 'Windows 8 Detected' -foregroundcolor yellow
			$web = Invoke-WebRequest https://www.microsoft.com/$Lang/download/confirmation.aspx?id=28972 -UseBasicParsing
        }
		elseif ($osInfo.Version.Minor -eq 3) { #Windows 8.1
			Write-host 'Windows 8.1 Detected' -foregroundcolor yellow
			$web = Invoke-WebRequest https://www.microsoft.com/$Lang/download/confirmation.aspx?id=39296 -UseBasicParsing
        }
    }elseif ($osInfo.Version.Major -eq 10) { #Windows 10
        if ($osInfo.Version.Minor -eq 0) {
			Write-host 'Windows 10 Detected' -foregroundcolor yellow
			$web = Invoke-WebRequest https://www.microsoft.com/$Lang/download/confirmation.aspx?id=45520 -UseBasicParsing
		}
    }
	if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64"){
		Write-host 'x64 Detected' -foregroundcolor yellow
		if ($osInfo.Version.Major -eq 6 -And $osInfo.Version.Minor -eq 0) {write-host 'Vista x64 is not supported, exiting';break}
	}else{
		Write-host 'x86 Detected' -forgroundcolor yellow
	}
	
	$toolsDir   = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
	$url        = $web.links.href |where-Object {$_ -like "*x86*" } | select-string -Pattern 'WS2016' -NotMatch | Select-Object -Unique 
	$url64      = $web.links.href |where-Object {$_ -like "*x64*" } | select-string -Pattern 'WS2016' -NotMatch | Select-Object -Unique

	$packageArgs = @{
	  packageName   = $packageName
	  fileType      = 'msu'
	  url           = $url
	  url64bit      = $url64
	  silentArgs    = "/quiet /norestart"
	  validExitCodes= @(0,3010,-2146233087,2359302)
	}
	Install-ChocolateyPackage @packageArgs
}
