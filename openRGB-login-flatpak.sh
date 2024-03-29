#!/bin/bash

#Helper functions
newline()
{
    echo ""
}

#Helper variables
SLEEP_TIME=9

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
    echo "      (ex. /path/to/openrgb-login.sh -c T)"
    echo "  -p    Tell script which profile OpenRGB will load after the script launches. Argument: string"
    echo "      (ex. /path/to/openrgb-login.sh -p \"Red_Breathing\")"
    echo "  -h    Display help. Argument: none"
    newline
    echo "  Note: After applying your settings, run the script again without any flags"
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

    echo "Auto close setting set. Launch the script again without any flags to execute."
    exit 0;
fi
if [[ -e "/home/$(logname)/.local/share/openrgb-autostart/close_after.txt" ]]
then
    CLOSE_AFTER=`cat /home/$(logname)/.local/share/openrgb-autostart/close_after.txt`
fi

newline
echo "Be sure you have flatpak version of OpenRGB installed, or this script will not execute correctly."
newline

#Run OpenRGB and apply profile
/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=openrgb org.openrgb.OpenRGB --startminimized --profile $RGB_PROFILE &

#If -c flag is set, if T, closes OpenRGB after applying profile, if F, keep OpenRGB open after applying profile.
#Default to T is -c flag is not set.
if [[ -n $CLOSE_AFTER ]]
then
    if [[ $CLOSE_AFTER = "T" ]]
    then
        echo "OpenRGB will close in 15 seconds. To stop this, set auto-close to False with \"-c F\" argument (Be sure to run the script again without any flags)"
        sleep $SLEEP_TIME

        flatpak kill org.openrgb.OpenRGB
        exit 0;
    else
        echo "OpenRGB will be kept open. To auto close OpenRGB after script execution, with \"-c T\" argument (Be sure to run the script again without any flags)"
        sleep $SLEEP_TIME
        exit 0;
    fi
else
    echo "OpenRGB will be kept open. To auto close OpenRGB after script execution, run the script with \"-c T\" argument (Be sure to run the script again without any flags)"
    sleep $SLEEP_TIME
    exit 0;
fi


exit 0;
