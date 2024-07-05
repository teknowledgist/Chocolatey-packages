import-module chocolatey-au

$moduleName  = 'importexcel'

function global:au_GetLatest {
    $version = (Find-Module -Name $moduleName).Version.ToString()

    return @{
        Version       = $version
    }
}

function global:au_SearchReplace {
    @{
    }
}

function global:au_BeforeUpdate() {
    do {
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ([GUID]::NewGuid()).ToString()
    }
    while (Test-Path $tempPath)
    New-Item -Path $tempPath -ItemType Directory | Out-Null

    Save-Module -Name $moduleName -RequiredVersion $Latest.Version -Path $tempPath
    $modulePath = Join-Path -Path $tempPath -ChildPath "\$ModuleName\$($Latest.Version)\"
    $zipPath = Join-Path -Path $tempPath -ChildPath "$moduleName.zip"
    Compress-Archive -Path (Join-Path -Path $modulePath -ChildPath "*") -DestinationPath $zipPath -CompressionLevel Optimal

    Move-Item -Path $zipPath -Destination 'tools\' -Force
}

update -ChecksumFor none