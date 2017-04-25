$ErrorActionPreference = 'Stop'

$packageName= 'axiovision'
$url        = ''
$url64      = '' 

<#
Download full installer from:
   http://download.zeiss.de/microscopy/axiovision/?C=M;O=D
unzip from path:
   \DVD 60 - Web-Version\x64\AVSE4.9\Setup\

Must use transform to prevent legacy Firewire drivers:
msiexec /i "Carl Zeiss AxioVision SE64 Rel. 4.9.1SP2.msi" /qb TRANSFORMS=NoFirewire2.mst

After install, many shortcuts have bad path:
   "C:\Program Files\Carl Zeiss Vision\AxioVision 4\AxioVision 4\AxioVs40x64.exe"
should be (duplicated folder removed):
   "C:\Program Files\Carl Zeiss Vision\AxioVision 4\AxioVs40x64.exe"

Uninstall shortcut (not in registry even though in programs and features):
"C:\Program Files\Carl Zeiss Vision\AxioVision 4\AxioVision 4\RunElevated.exe" msiexec.exe /i{B6003C2B-A45B-4E2A-8141-A64547B48FCF}

Also need to download the service pack and install it.
#>
