import-module au

$url                    = 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'
$checksumTypePackageMSP = "SHA512"

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
            "(^\s*[$]*urlPackageMSP\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^\s*[$]*checksumPackageMSP\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^\s*[$]*checksumTypePackage\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }; 
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive

    $reLatestbuild = "(.*>DC.*)"
    $download_page.RawContent -imatch $reLatestbuild
    $latestbuild   = $Matches[0]

    $reVersion   = "(\d+)(.)(\d+)(.)(\d+)"
    $latestbuild -imatch $reVersion
    $version     = "20$($Matches[0])"
    $urlVersion  = $Matches[0].Replace(".", "")
    
    $urlPackageMSP = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/$($urlVersion)/AcroRdrDCUpd$($urlVersion)_MUI.msp"

    return  @{ 
        URL32          = $urlPackageMSP;
        ChecksumType32 = $checksumTypePackageMSP;
        Version        = $version
    }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme $Package -SkipFirst 3
}

update





$DownloadFolder = "E:\Adobe_Acrobat_Reader_DC_MUI\"
$FTPFolderUrl = "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/"

#connect to ftp, and get directory listing
$FTPRequest = [System.Net.FtpWebRequest]::Create("$FTPFolderUrl") 
$FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
$FTPResponse = $FTPRequest.GetResponse()
$ResponseStream = $FTPResponse.GetResponseStream()
$FTPReader = New-Object System.IO.Streamreader -ArgumentList $ResponseStream
$DirList = $FTPReader.ReadToEnd()

#from Directory Listing get last entry in list, but skip one to avoid the 'misc' dir
$LatestUpdate = $DirList -split '[\r\n]' | Where {$_} | Select -Last 1 -Skip 1

#build file name
$LatestFile = "AcroRdrDCUpd" + $LatestUpdate + "_MUI.msp"

#build download url for latest file
$DownloadURL = "$FTPFolderUrl$LatestUpdate/$LatestFile"

#download file
(New-Object System.Net.WebClient).DownloadFile($DownloadURL, "$DownloadFolder$LatestFile")