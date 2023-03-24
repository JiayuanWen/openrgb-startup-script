#!/bin/bash

#Helper functions
newline()
{
    echo ""
}

#Get flag values
while getopts c:p:h flag
do
    case "${flag}" in
        c)  close_openrgb="${OPTARG}";;
        p)  rgb_profile="${OPTARG}";;
        h)  display_help=true;;
        #Handles flag missing argument
        ?)  newline
            echo "Run with \"-h\" flag for help"
            newline
            exit 1
            ;;
    esac
done

#Check if config folder exist
if [ ! -d /home/$(logname)/.local/share/openrgb-autostart/ ]
then
    mkdir "/home/$(logname)/.local/share/openrgb-autostart"
fi

#Check if config files exist
if [ ! -e /home/$(logname)/.local/share/openrgb-autostart/close_after.txt ]
then
    touch "/home/$(logname)/.local/share/openrgb-autostart/close_after.txt"
fi
if [ ! -e /home/$(logname)/.local/share/openrgb-autostart/profile.txt ]
then
    touch "/home/$(logname)/.local/share/openrgb-autostart/profile.txt"
fi

#Display help if -h flag
if [ "$display_help" = true ]
then
    for i in 1 2
    do
        newline
    done
    echo "Config flags:"
    echo "  -c    Tell script to close OpenRGB or keep it open after applying preset. Argument: \"T\" or \"F\""
    echo "  -p    Tell script which profile OpenRGB will load after the script launches. Argument: string"
    echo "  -h    Display help. Argument: none"
    newline
    exit 0;
fi

#Save profile name set by -p flag
if [ -n "$rgb_profile" ]
then
    echo "$rgb_profile" > "/home/$(logname)/.local/share/openrgb-autostart/profile.txt"

    echo "Color profile set. Launch the script without any flags to execute."
    exit 0;
fi
if [[ -e "/home/$(logname)/.local/share/openrgb-autostart/profile.txt" ]]
then
    RGB_PROFILE=`cat /home/$(logname)/.local/share/openrgb-autostart/profile.txt`
fi

#Save settings set by -c flag
if [[ -n "$close_openrgb" ]]
then
    if [[ "$close_openrgb" -ne "T" ]] || [[ "$close_openrgb" -ne "F" ]]
    then
        echo "T" > "/home/$(logname)/.local/share/openrgb-autostart/close_after.txt"
    else
        echo "$close_openrgb" > "/home/$(logname)/.local/share/openrgb-autostart/close_after.txt"
    fi

    echo "Auto close setting set. Launch the script without any flags to execute."
    exit 0;
fi
if [[ -e "/home/$(logname)/.local/share/openrgb-autostart/close_after.txt" ]]
then
    CLOSE_AFTER=`cat /home/$(logname)/.local/share/openrgb-autostart/close_after.txt`
fi

#Run OpenRGB and apply profile
newline
echo "Be sure you have flatpak version of OpenRGB installed, or this script will not execute correctly."
newline
/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=openrgb org.openrgb.OpenRGB --startminimized --profile $RGB_PROFILE &
sleep 15;

#If -c flag is set, if T, closes OpenRGB after applying profile, if F, keep OpenRGB open after applying profile.
#Default to T is -c flag is not set.
if [[ -n "$CLOSE_AFTER" ]]
then
    if [[ "$CLOSE_AFTER" -eq "T" ]]
    then
        echo "OpenRGB will close in 15 seconds. To stop this, run the script with \"-c F\" argument"
        flatpak kill org.openrgb.OpenRGB
    fi
fi

exit 0;
