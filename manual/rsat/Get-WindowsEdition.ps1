# This package requires certain editions of Windows.  The WMI code:
#    (Get-WmiObject Win32_OperatingSystem).Caption
# provides a language-specific description of the edition.  
# The following will create a list of Windows editions and return
# the "official" English name.  
# See:  https://superuser.com/questions/1328506/windows-edition-on-non-english-systems

$page = Invoke-WebRequest -uri 'https://msdn.microsoft.com/en-us/library/ms724358.aspx'

$TableText = ($page.AllElements | 
            Where-Object {$_.tagname -eq 'tbody' -and $_.innertext -like 'valuemeaning*'} |
            Select-Object -ExpandProperty innertext) -split "`r`n"

$CSV = $TableText | Where-Object {$_ -match '^0x0.*'} | 
            ForEach-Object {$_ -replace "^(0x0[0-9A-F]+) ",'$1,'} |
            ForEach-Object {"$([convert]::ToInt16($_.split(',')[0],16))" + ',' + $_.split(',')[-1]}

$SKUs = ConvertFrom-Csv $CSV -Header 'sku','Name'

$ThisOS = (Get-WmiObject Win32_OperatingSystem).operatingsystemsku

$SKUs | Where-Object {$_.sku -eq $ThisOS} |Select-Object -ExpandProperty name
