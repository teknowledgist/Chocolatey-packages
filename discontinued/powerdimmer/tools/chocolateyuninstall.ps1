$File = Join-Path $env:SystemRoot 'system32\powerdimmer.scr'
 
if ([System.IO.File]::Exists($File)) {
    Write-Debug "Found the Power Dimmer screensaver file. Deleting it..."
    [System.IO.File]::Delete($File)
}
