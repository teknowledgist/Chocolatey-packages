ILLiad allows you to replace paper-based workflows, manage a high volume of requests and automate routine functions for borrowing and lending resources between libraries with integration into a variety of third-party systems. ILLiad allows your users to place and monitor their requests without librarian assistance and to get materials quickly.

### Optional Parameters
By default, this package will install all components of the ILLiad client installer put all the shortcuts on the public desktop (which can't be removed by unprivileged users) and require each user to set the path to the DB Connection (i.e. .dbc file).  Use the following optional package parameters to change that: 

* `/Skip:(list-of-components)` - The components listed will not be installed.  Possible component names are: 'ILLiadClient', 'StaffManager', 'CustomizationManager', 'ElectronicDeliveryUtility', 'SAM', 'BillingManager'
* `/NoIcons` - All icons created by the installer on the public desktop will be removed before completion.
* `/CleanIcons` - The ILLiad icons created on the public desktop will be moved to an "ILLiad Tools" folder on the public desktop.  This essentially replaces 5 desktop icons with a single one for organization.  The "Atlas SQL Alias Manager" (not part of ILLiad) will remain on the desktop.  `/NoIcons` *takes precedence over this parameter.*
* `/DBCfile:(local or UNC path to .dbc file)` - The path to an ILLiad .dbc file will be preset for the current user and future users (not other already established profiles) eliminating the need for users to use the "Alias Manager" on first use.  **Note** This package does not check the validity of the given path.
* `/Default` - (only with `/DBCfile`) Sets the DBC file path as the system-wide default for ILLiad.

Example:

`choco install illiad-client --params '"/Skip:BillingManager /NoIcons /DBCfile:\\illiadserver\share\logon.dbc /Default"'`

## Why is this package not on [the public repository](https://chocolatey.org/packages)?
Atlas requires credentials to download ILLiad client installers, and neither Atlas nor OCLC provide a license for terms of use or distribution which is required for public packages.   