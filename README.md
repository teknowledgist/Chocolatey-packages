# Chocolatey-packages

### Description

This repository contains [chocolatey packages](https://chocolatey.org/profiles/teknowledgist) created and maintained by me.  

#### Self-imposed guidelines

1. As much as possible, these packages are [automatic](https://chocolatey.org/docs/automatic-packages) and all automatic packages will use the [AU module](https://github.com/majkinetor/au).
2. If allowed, packages will include the packaged software directly in the `.nupkg` archive instead of downloading it from another site at the time of install.  Only tools that allow redistribution in their license can be embedded and such packages must include two additional files in the `tools` directory - `VERIFICATION.txt` and `License.txt`.
3. Code is written for humans, not for computers (i.e. assembly).  Thus, I attempt to make the code readable and commented, but also efficient.  My goal is not to obfuscate.  If I haven't looked at the code in a while, I want to understand it too!
4. I attempt to fill all metadata attributes in the package.  If a metadata tag is empty, it is because I could not find the information.  I often will contact the publisher of software if I feel metadata should be publicly presented.

##### Tags

A tag is a keyword or term used to describe or assign a classification to a package for the purpose of easily finding the package via search. Tags are a requirement in the Chocolatey nuspec file. 

1. At this point, I can think of four distinct kinds of tags for packages:
    1. **License tags**:  At least one of these are required.  
        1. *foss*: free and open source packages
        2. *freeware*: free-to-use but not open source packages
        3. *trial*: closed-source, commercial packages that eventually require a license
        4. *licensed*: closed-source, commercial packages that are free to download, but require a license to function -- even the first time
    2. **Classification tags**: At least one of these are highly recommended.
        1. productivity
        2. programming
        3. utility
        4. browser
        5. driver
        6. server
        7. client
        8. addon
        9. social
        10. game
        11. media
    3. **Qualification tags**: Individually required if a package meets the qualification:
        1. portable - software does not require admin rights to install or use.
        2. notsilent - package causes windows or splash-screens to open or close.
        3. interactive - package requires interaction by the user (this ishighly discouraged).
        4. installonly - software cannot be uninstalled through Chocolatey.
        5. embedded - package `.nupkg` is self-contained and does not require additional downloads.
    4. **Synonym tags**: These are the most "personal" and wide-ranging of the choices made by the maintainer and are difficult to suggest or predefine. These are also the most likely to help someone find a specific, obscure package.  Some considerations:
        1. alternate spellings, nicknames or abbreviations.  e.g. spice, 
        2. subject matter.  e.g. chemistry, architecture, geology, LaTeX, CAD, GIS, 3d
        3. purpose.  e.g. measure, plot, draft, privacy, print
        4. specific target. e.g. pdf, png, tex, dos, java
        5. replacement for. e.g. Notepad, Explorer, Acrobat


        
        
