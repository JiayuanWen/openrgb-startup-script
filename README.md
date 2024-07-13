# OpenRGB startup script
Linux bash script for applying [OpenRGB](https://openrgb.org/) lighting profiles. Can be used as system startup script (Execute upon login). \
This is a workaround for OpenRGB's `Start At Login` option not working on some version of the app, such as AppImage or Flatpak. 
> [!NOTE]
> Only scripts for AppImage, Flatpak, and native version of OpenRGB avaliable.

## Installation
See [Wiki](https://github.com/JiayuanWen/openrgb-startup-script/wiki) for installation instructions for your version of OpenRGB.

## Usage
#### Change which profile to load
Tell OpenRGB which RGB profile to load to your PC setup upon script execution.
* Run ```/path/to/openRGB-login.sh -p <profile name>```
* You can then run `/path/to/openRGB-login.sh` without any flag to execute the script.

#### Change whether to close OpenRGB after applying a profile
If set to true, OpenRGB will close itself after applying a profile, otherwise it will keep running in the background (You can see system tray icon).
* Run the script with -c flag:
  *   ```/path/to/openRGB-login.sh -c T``` to set closing OpenRGB to true
  *   ```/path/to/openRGB-login.sh -c F``` to set closing OpenRGB to false
* You can then run `/path/to/openRGB-login.sh` without any flag to execute the script.

## Execute on Startup
You can set the script to execute on login. \
The steps depend on your desktop environment (Plasma, GNOME, Cinnamon, Mate...), so you will have to search it up how to setup login scripts for your DE. 

