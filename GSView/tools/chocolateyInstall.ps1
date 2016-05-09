$name='GSView'
$url32='http://pages.cs.wisc.edu/~ghost/gsview/download/gsv50w32.exe'
$url64='http://pages.cs.wisc.edu/~ghost/gsview/download/gsv50w64.exe'

Install-ChocolateyPackage "$name" exe "$url32" "$url64"
