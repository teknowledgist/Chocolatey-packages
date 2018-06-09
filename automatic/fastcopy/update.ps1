# First load the functions that the dependency (i.e. ".install") package uses
. "$((pwd).path + '.install')\update.ps1"

# Then re-define the "au_SearchReplace" function to update this package
function global:au_SearchReplace {
   @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).portable`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
            "(<projectSourceUrl>).*(</projectSourceUrl>)" = "`$1$($Latest.SourceURL)`$2"
        }
    }
}

update -ChecksumFor none