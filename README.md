# openrgb-startup-script-flatpak
Linux bash script for opening [OpenRGB](https://openrgb.org/), applying an indicated lighting profile, then closes. Can be used to apply RGB lighting profile on system startup.

## Prerequisites
* Flatpak version of OpenRGB

## Usage
#### Change which profile to load
Tell OpenRGB which RGB profile to load to your PC setup upon script execution.
* Run ```/path/to/openRGB-login-flatpak.sh -p <profile name>```, no sudo permission needed.
* You can then run `/path/to/openRGB-login-flatpak.sh` without any flag to execute the script.

#### Change whether to close OpenRGB after applying a profile
If set to true, OpenRGB will close itself after applying a profile, otherwise it will keep running in the background (You can see system tray icon).
* Run the script with -c flag:
  *   ```/path/to/openRGB-login-flatpak.sh -c T``` to set closing OpenRGB to true
  *   ```/path/to/openRGB-login-flatpak.sh -c F``` to set closing OpenRGB to false
* You can then run `/path/to/openRGB-login-flatpak.sh` without any flag to execute the script.
