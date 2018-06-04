# First load the functions that the dependency (i.e. ".install") package uses
. "$((pwd).path -replace 'portable','install')\update.ps1"

# Then re-define the "au_SearchReplace" function to update this package
function global:au_SearchReplace {
   @{
        "$($Latest.PackageName).nuspec" = @{
            "(<projectSourceUrl>).*(</projectSourceUrl>)" = "`$1$($Latest.SourceURL)`$2"
        }
    }
}

update -ChecksumFor none