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

#Check if OpenRGB folder exist locally
if [ ! -d "/home/$(logname)/.var/app/org.openrgb.OpenRGB/config/OpenRGB/" ]
then
    mkdir "/home/$(logname)/.var/app/org.openrgb.OpenRGB/config/OpenRGB/"
fi

#Check if config folder exist
if [ ! -d "/home/$(logname)/.var/app/org.openrgb.OpenRGB/config/OpenRGB/autostart/" ]
then
    mkdir "/home/$(logname)/.var/app/org.openrgb.OpenRGB/config/OpenRGB/autostart/"
fi

#Check if config files exist
CONFIG_FILE="/home/$(logname)/.var/app/org.openrgb.OpenRGB/config/OpenRGB/autostart/autostart_config"
if [ ! -e $CONFIG_FILE ]
then
    touch $CONFIG_FILE
    cat <<EOF > $CONFIG_FILE
#This is the config file read by OpenRGB autostart script. You may manually change the settings here, or change it via the autostart script (see: https://github.com/JiayuanWen/openrgb-startup-script?tab=readme-ov-file#usage)

#This setting determines the lighting profile OpenRGB will open
openrgb_autostart_profile=none

#This setting tells script rather to close OpenRGB after opening lighting profile
openrgb_autostart_close_after=T
EOF
fi
source $CONFIG_FILE #See "/home/<username>/.var/app/org.openrgb.OpenRGB/config/OpenRGB/autostart/autostart_config" for all variables that will be used later in the script

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
    sed -i "s/^openrgb_autostart_profile=.*/openrgb_autostart_profile=$rgb_profile/" $CONFIG_FILE

    echo "Color profile set. Launch the script without any flags to execute."
    exit 0;
fi

if [[ -e $CONFIG_FILE ]]
then
    RGB_PROFILE="$openrgb_autostart_profile"
fi

#Save auto-close settings set by -c flag
if [ -n "$close_openrgb" ]
then
    if [[ "$close_openrgb" == "T" ]] || [[ "$close_openrgb" == "F" ]]
    then
        sed -i "s/^openrgb_autostart_close_after=.*/openrgb_autostart_close_after=$close_openrgb/" $CONFIG_FILE
        echo "Auto close setting set. Launch the script again without any flags to execute."
    else
        echo "Auto close setting must be "T" or "F". Setting not set."
        exit 1;
    fi

    exit 0;
fi

if [[ -e $CONFIG_FILE ]]
then 
    CLOSE_AFTER="$openrgb_autostart_close_after"
fi


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
