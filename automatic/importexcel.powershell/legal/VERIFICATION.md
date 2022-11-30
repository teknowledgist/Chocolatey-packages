# VERIFICATION
Verification is intended to assist the Chocolatey moderators and community in verifying that this package's contents are trustworthy.

## Download
There are several options for obtaining the files contained in the embedded zip file:

1. Each of the individual files contained in the zip file can be found at the project source location (https://github.com/dfinke/ImportExcel)
2. A zip file (not matching the embedded one) for each release can be downloaded from the releases page (https://github.com/dfinke/ImportExcel/releases) and expanded.  *Note: here are some additional files in that download that are not in the embedded zip file.*
3. Download the module from the PowerShell Gallery `Save-Module -Name ImportExcel -Path <PATH TO DOWNLOAD TO>`

## Verify
You can use one of the following methods to obtain the checksum of any individual file and compare it with the corresponding reference file:
1. Use powershell function 'Get-Filehash'
2. Use chocolatey utility 'checksum.exe'

Alternatively, install the [`multihasher` Chocolatey package](https://community.chocolatey.org/packages/multihasher) to calculate all checksums of collections of files.

## License
File 'LICENSE.txt' is obtained from:
- https://github.com/dfinke/ImportExcel/blob/master/LICENSE.txt
