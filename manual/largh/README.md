Are you a Chocolatey package maintainer for software released on GitHub?  Have you noticed that GitHub has made it increasingly difficult to scrape pages for information on the latest release?

The **La**test **R**elease on **G**it**H**ub Helper can help you!  

Maybe you use [AU](https://community.chocolatey.org/packages/au) or maybe you have another process for updating your packages.  Regardless, you no longer need to parse raw HTML to nab the version or to snag the URL for the download.  This package gives you a PowerShell function that leverages the GitHub API so that you to easily check for the latest version of any (public) project.  It can be as simple as:

    `$Release = Get-LatestReleaseOnGitHub -URL https://www.github.com/ownername/repositoryname`
    `$version = $Release.Tag.trim('v.')`
    `$URL = $Release.Assets | Where-Object {$_.FileName -match '\.exe'} | Select-Object -ExpandProperty DownloadURL`

The `$Release` object will contain the name of the latest release, the principle tag (which usually contains the version), the description, the URLs for the "zipball" and "tarball" of the release code, and finally, information on each of the "assets" (i.e. files) for the release like the filename, date, size and full download URL.

Sure, you can do this yourself by installing the [PowerShellForGitHub](https://github.com/microsoft/PowerShellForGitHub) module and reading the documentation, but that's overkill for what you need to do.  Install this package and **keep it simple**.  It even has a shortened alias:

![Example](https://cdn.jsdelivr.net/gh/teknowledgist/Chocolatey-packages@51d4fa25c1ed5feff746e4f5870741d8980fdceb/manual/largh/Example.png)

### Note for maintainers with LOTS of packages
The GitHub API has a speed limit of 60 queries per hour.  If you have so many packages or check for updates so often that you might exceed that limit, you can [create an Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).  The Token needs no special scope or permissions and will allow you to make up to 5000 queries per hour.  (Surely that is enough!)  This package allows you to provide the token as a one-time thing (less safe), or have it cached so you only need to provide it once on each computer you use.

##### Examples:
* `Get-LARGH -URL https://github.com/ownername/repositoryname -AccessToken a1b2c3d4e5f6g7h8i9j0`  
    This will use the token just one time.  Other than a quick test, this is not particularly helpful unless you are going to put your access token in plaintext in your code (not a good idea!), but you do things your way.

* `Get-LARGH -URL https://github.com/ownername/repositoryname -TokenAsCred`  
    This will request the token in a credential window and then store it encrypted within the user profile.  All future uses of the function will use the cached credential without needing the switch until the `-credential` switch is used again and an empty/blank password is provided. 

#### Requirements
* PowerShell v3