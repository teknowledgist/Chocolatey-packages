### So, you want to install Shockwave?

While the technology is outdated, and there are [recommendations against using or even having it](https://krebsonsecurity.com/2014/05/why-you-should-ditch-adobe-shockwave/), sometimes it is required by certain uncaring monopolies (Pearson textbooks, for example).

The ["consumer" version of the installer available here](<https://fpdownload.macromedia.com/get/shockwave/default/english/win95nt/latest/Shockwave_Installer_Full.exe>) does not install nicely.  It cannot be made silent, and it tries to install toolbars or other garbage.  There are credible reports that it also requires admin credentials for each non-admin user to work.

Adobe does have another installer release, but it requires a distribution license.  While there is no technical barrier to downloading the latest distribution installer, the distribution license specifically disallows sharing the URL.  You can [request your own distribution license](http://www.adobe.com/products/players/fpsh_distribution1.html).

Once you have rights to re-distribute the Adobe Shockwave Player, modify the update.ps1 file to include the download URL.  Then run the update script (the "au" chocolatey package must be installed) to download the installer and make a local package for your internal use.
