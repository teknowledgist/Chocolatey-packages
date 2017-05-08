Screensaver Operations for Windows
The Grim Admin http://www.grimadmin.com/staticpages/index.php/ss-operations

---

### CONTACT INFORMATION
Comments or software bugs may be reported to The Grim Admin at http://www.grimadmin.com/profiles.php?uid=2
Alternate e-mail contact: admin @ grimadmin.com


### INSTALLATION

32-bit & 64-bit Windows: Copy "Screensaver Operations.scr" to C:\Windows\System32 (you can use the same SCR file for both 32-bit & 64-bit Windows).

Alternatively, you can use the included Windows Installer (MSI) files to easily deploy using Group Policy or other means.


### SINGLE USER CONFIGURATION

Using the Windows Control Panel, select "Screensaver Operations" as your screensaver and click the "Settings..." button.


### CONFIGURE GROUP POLICY TO ENFORCE SCREENSAVER

Apply settings using the Group Policy snap-in under Computer Policy\User Configuration\Administrative Templates\Control Panel\

NOTE: Some Group Policy adjustments may not take effect until your users log off and back on again. For example, a change to the screen saver timeout value usually doesn't take effect until the affected user logs off and on again, even though the textbox in the "Screen Saver Settings" window shows the new value.

##### Windows 2000, XP, or Server 2003: 

|       SETTING         |                  DESCRIPTION                      |
| --------------------- | ------------------------------------------------- |
| Display\Hide screen saver tab  |      Removes Screen Saver tab from Display in Control Panel. |
| Display\Password protect the screen saver | Enable to set passwords on all screen savers.  Disable to prevent passwords from being used on all screen savers. | 
| Display\Screen Saver | Enables/Disables desktop screen savers. |
| Display\Screen saver executable name | Specifies the screen saver for the user's desktop and prevents changes. |
| Display\Screen Saver timeout | Specifies how much user idle time (in seconds) must elapse before the screen saver is launched. |


##### Windows Vista, 7, or Server 2008:

|       SETTING         |                  DESCRIPTION                      |
| --------------------- | ------------------------------------------------- |
| Personalization\Enable screen saver | Enables/Disables desktop screen savers. |
| Personalization\Force specific screen saver | Specifies the screen saver for the user's desktop and prevents changes. |
| Personalization\Password protect the screen saver | Enable to set passwords on all screen savers. Disable to prevent passwords from being used on all screen savers. |
| Personalization\Prevent changing screen saver | Prevents the Screen Saver dialog from opening in the Personalization or Display Control Panel. |
| Personalization\Screen Saver timeout | Specifies how much user idle time (in seconds) must elapse before the screen saver is launched. |

### ENFORCE SCREENSAVER USING WINDOWS REGISTRY

If your clients are not on a domain or you cannot use policies to configure the screensaver, below are the appropriate registry keys. 

Apply settings under `HKEY_CURRENT_USER\Control Panel\Desktop\`

|       SETTING         |                  DESCRIPTION                      |
| --------------------- | ------------------------------------------------- |
| ScreenSaveActive (REG_SZ) | Enables/Disables desktop screen savers (0=disabled; 1=enabled).|
| ScreenSaverIsSecure (REG_SZ) | Enable to set passwords on all screen savers (0=disabled; 1=enabled). |
| ScreenSaveTimeOut (REG_SZ) | Specifies how much user idle time (in seconds) must elapse before the screen saver is launched. |
| SCRNSAVE.EXE (REG_SZ) | Specifies the screen saver for the user's desktop; you may need to use the 8.3 filename (e.g., "C:\Windows\System32\SCREEN~1.SCR"). |

### USER SETTINGS

USER settings are stored under HKEY_CURRENT_USER (HKCU) at `HKEY_CURRENT_USER\Software\GrimAdmin.com\Screensaver Operations`.
- This is very useful if you want to use scripts, Group Policy Preferences, or the included ADMX files to push out settings to your users.
- Since users can change USER settings, they cannot be enforced (you can still overwrite their stored registry settings).

### MACHINE SETTINGS

MACHINE settings are stored under HKEY_LOCAL_MACHINE (HKLM) at `HKEY_LOCAL_MACHINE\SOFTWARE\GrimAdmin.com\Screensaver Operations`.
- Important Note: For backwards compatibility with older versions, SSO will still pull settings from the HKLM Wow6432node registry key on 64-bit systems if you don't have settings at `HKEY_LOCAL_MACHINE\SOFTWARE\GrimAdmin.com\Screensaver Operations`.
- You can set DEFAULT settings for all users on a machine by creating registry values under HKEY_LOCAL_MACHINE. 
- If any USER settings exist, they will take precedence over MACHINE settings unless you enable the "LocalMachineOverride" value. Enabling "LocalMachineOverride" is very useful if you want to enforce any MACHINE settings since users will not be able to change these settings (unless they are local admin and know how to edit the HKLM registry).
- Use scripts, Group Policy Preferences, or the included ADMX files to push out settings to your computers.

### SCREENSAVER OPERATIONS CONFIGURABLE REGISTRY SETTINGS

NOTE: With the exception of "LocalMachineOverride" all settings can be applied to either HKCU or HKLM.

--------------------------------

##### LocalMachineOverride (REG_DWORD)

* Description: Causes MACHINE settings (HKLM) to take precedence over USER settings (HKCU). 
* Format: integer (0=disabled; 1=enabled; default=0)
* NOTE: Applies to MACHINE registry (HKLM) only.

##### EWX_ExitFlag (REG_DWORD)

* Description: Sets the Windows Exit command. 
* Format: integer (default=0)
* Possible Values:
    * 0  - (0x0) Log Off
    * 4  - (0x4) Forced Log Off (0 + 4)
    * 1  - (0x1) Shutdown
    * 5  - (0x5) Forced Shutdown (1 + 4)
    * 2  - (0x2) Reboot
    * 6  - (0x6) Forced Reboot (2 + 4)
    * 8  - (0x8) Power Off
    * 12 - (0xC) Forced Power Off (8 + 4)
    * 90 - Suspend
    * 91 - Hibernate
    * 94 - Forced Suspend
    * 95 - Forced Hibernate
    * 99 - Does Nothing (used for testing)

##### CancelOnMouseClick (REG_DWORD)

* Description: Enables the ability to cancel the screensaver when a mouse button is clicked.
* Format: integer (0=disabled; 1=enabled; default=0)
* NOTE: Experimental setting - can only be set via registry and ADMX (setting not available in the configuration GUI).

##### CancelOnMouseMove (REG_DWORD)

* Description: Enables the ability to cancel the screensaver when the mouse is moved.
* Format: integer (0=disabled; 1=enabled; default=0)
* NOTE: Experimental setting - can only be set via registry and ADMX (setting not available in the configuration GUI).

##### DelayInSeconds (REG_DWORD)

* Description: How long to display warning message before performing specified action. Setting to 0 will cause action to occur immediately.
* Format: integer between 0 and 2,147,483,647 (default=60)

##### DisableSpecialKeys (REG_DWORD)

* Description: Disables special keys and key combinations such as the Windows key, Alt+Tab, Alt+Esc, Ctrl+Esc, Ctrl+Shift+Esc. Does not disable Ctrl+Alt+Del or Alt+F4.
* Format: integer (0=disabled; 1=enabled; default=1)

##### HideActionButton (REG_DWORD)

* Description: Removes the Action Button from the screensaver dialog window.
* Format: integer (0=disabled; 1=enabled; default=0)

##### RunProcessEnabled (REG_DWORD)

* Description: Causes screensaver to ignore the EWX_ExitFlag value and run a specified process instead.
* Format: integer (0=disabled; 1=enabled; default=0)

##### RunProcessPath (REG_SZ)

* Description: Path to executable; used in conjunction with RunProcessEnabled.
* Format: string (e.g., "C:\Windows\notepad.exe")

##### RunProcessArguments (REG_SZ)

* Description: Arguments to pass to executable; used in conjunction with RunProcessEnabled.
* Format: string (e.g., "/s /p")

##### MessageFontSize (REG_DWORD)

* Description: Sets font size of message text.
* Format: integer between 1 and 1,638 (default=9)

##### CustomTitleText (REG_SZ)

* Description: Allows you to display a custom text in the title rather than one of the default titles.
* Format: string (e.g., "Windows is now logging off")
* NOTE: Setting CustomTitleText to "" will cause one of the default titles to appear. If you want no text to appear, enter a space " ".

##### CustomMessage (REG_SZ)

* Description: Allows you to display a custom message rather than one of the default messages.
* Format: string (e.g., "Your computer is about to shutdown!")
* NOTE: Setting CustomMessage to "" will cause one of the default messages to appear. If you want no text to appear, enter a space " ".
* Optional Variables:
    * `%time_remaining%` - Displays the time remaining in seconds (e.g., "Your computer will shutdown in %time_remaining% seconds.").
    * `%time_remaining_h%` - Displays the hours component of the time remaining in H:M:S format.
    * `%time_remaining_m%` - Displays the minutes component of the time remaining in H:M:S format.
    * `%time_remaining_s%` - Displays the seconds component of the time remaining in H:M:S format.
    * `%time_remaining_hp%` - Displays the hours component of the time remaining in two-digit padded HH:MM:SS format.
    * `%time_remaining_mp%` - Displays the minutes component of the time remaining in two-digit padded HH:MM:SS format.
    * `%time_remaining_sp%` - Displays the seconds component of the time remaining in two-digit padded HH:MM:SS format.
    * `%time_elapsed%` - Displays the time elapsed in seconds.
    * `%time_elapsed_h%` - Displays the hours component of the time elapsed in H:M:S format.
    * `%time_elapsed_m%` - Displays the minutes component of the time elapsed in H:M:S format.
    * `%time_elapsed_s%` - Displays the seconds component of the time elapsed in H:M:S format.
    * `%time_elapsed_hp%` - Displays the hours component of the time elapsed in two-digit padded HH:MM:SS format.
    * `%time_elapsed_mp%` - Displays the minutes component of the time elapsed in two-digit padded HH:MM:SS format.
    * `%time_elapsed_sp%` - Displays the seconds component of the time elapsed in two-digit padded HH:MM:SS format.
    * `%user_name%` -> Shows the currently logged on user's username.
    * `%user_domain_name%` -> Shows the current user's domain name.
    * `%machine_name%` - Shows the current computer name.

##### GradientColorLeft (REG_SZ) & GradientColorRight (REG_SZ)

* Description: Allows you to customize the background colors of the banner text. Setting both values the same will cause a solid color while having different colors will cause a color gradient.
* Format: hex triplet (e.g., "#054E85")
* NOTE: Make sure you include the preceding pound "#" symbol.

### TROUBLESHOOTING

* **Issue:** Error message "Unhandled exception has occurred in a component in your application. If you click Continue the application will ignore this error and attempt to continue. [some value] is not a valid value for Int32."
**Solution:** Make sure that any specified settings are within the appropriate range and configured properly. In addition, make sure you have the correct value type for registry entries (i.e., REG_DWORD vs. REG_SZ).

* **Issue:** Odd red lines appear throughout the warning dialog box.
**Solution:** Verify that your color values are in hex triplet format (e.g., "#054E85") and that you've included the preceding pound "#" symbol.

* **Issue:** Error message "Unable to find a version of the runtime to run this application."
**Solution:** Make sure you have .NET Framework 2.0 (or higher) installed.

* **Issue:** Screensaver crashes when a keyboard key is pressed.
**Solution:** In rare instances, 3rd party software already loaded on your machine may conflict with the disabling of special keys and key combinations. Disable this feature through the configuration screen or by setting the registry value "DisableSpecialKeys" to 0.

* **Issue:** Screensaver does not run if power options turn off the display.
**Solution:** Make sure the wait time for the display power save mode is longer than that of the screensaver. This is by design in Microsoft Windows (if there is no signal being sent to your display, you wouldn't need a 'screen saver').

### VERSION INFORMATION

Documentation relevant for Screensaver Operations version 1.4.3.0
Check for new version at http://www.grimadmin.com/staticpages/index.php/ss-operations-versioncheck?version=1.4.3.0

### COPYRIGHT NOTICE
Copyright © GrimAdmin.com 2009-2013
All rights reserved
