$InstallArgs = @{
   PackageName = 'hpglviewer'
   Url = 'http://service-hpglview.web.cern.ch/service-hpglview/download/hpglview-543_Windows.zip' 
   UnzipLocation = Join-Path $env:ProgramFiles 'HpglView'
}
Install-ChocolateyZipPackage @InstallArgs

New-Item -Path 'HKLM:\SOFTWARE\Classes\.hp2' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\.hpg' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\.hpgl' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\.plt' -Value 'HpglView' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\HpglView' -Value 'HP-GL Image' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\HpglView\shell' -Value 'open' -force | Out-Null
New-Item -Path 'HKLM:\SOFTWARE\Classes\HpglView\shell\open\command' -Value '"\"C:\\Program Files\\HpglView\\hpglview.exe\" \"%1\""' -force | Out-Null

