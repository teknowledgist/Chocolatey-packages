import-module au

$Release = 'https://github.com/Lyndir/MasterPassword/releases'

function global:au_GetLatest {
   $ReleasesPage = Invoke-WebRequest -Uri $Release

   $version = ($ReleasesPage.links | 
                  Where-Object {$_.innertext -Match 'java'} | 
                  Select-Object -First 1 -ExpandProperty innertext).split("-")[0]

   return @{ Version = $version }
}

function global:au_SearchReplace {
    @{
         "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).portable`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.Version)`""
         }
    }
}

update -ChecksumFor none