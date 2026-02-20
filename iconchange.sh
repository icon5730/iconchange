#!/bin/bash

#Author: Ilya Polnarov
#Date: 17/01/2026

#Colors
red="\e[31m"                     
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
cyan="\e[36m"
magenta="\e[35m"
endcolor="\e[0m"

stty -echoctl #Disable ctrl+c feedback in the terminal

trap 'stty echoctl' EXIT #Restore ctrl+c feedback in the terminal on exit

trap 'echo -e "\n${red}[!]${endcolor} User interrupt (${yellow}Ctrl+C${endcolor})"; sleep 0.2 ; exit 130' SIGINT #Display personalized message on exit by trapping the ctrl+x sigint

foxfile=("firefox.desktop" "firefox-beta.desktop" "firefox-esr.desktop" "firefox-nightly.desktop" "firefox-developer.desktop") #Suppoered Firefox versions. Feel free to edit this array in case your version is missing
for file in $foxfile; do
    if [ -f "/usr/share/applications/$file" ]; 
    	then
        foxpath+=("/usr/share/applications/$file")
    fi
done

birdfile=("thunderbird.desktop" "thunderbird-daily.desktop" "thunderbird-esr.desktop" "thunderbird-nightly.desktop") #Suppoered Thunderbird versions. Feel free to edit this array in case your version is missing
for bfile in $birdfile; do
    if [ -f "/usr/share/applications/$bfile" ]; 
    	then
        birdpath+=("/usr/share/applications/$bfile")
    fi
done

#Restore function, responsible for restoring the .desktop files to their default values
rstr(){
if [[ $OPTARG == "firefox" ]];
	then
	if [ ! -f "${foxpath[@]}" ];
		then
		echo -e "${red}[!]${endcolor} Firefox config file missing" 1>&2 ; sleep 0.2 ; exit 1
	fi
	sleep 0.3 ; echo -e "\n${cyan}[-]${endcolor} Restoring Firefox icon to default settings..." ; sleep 0.2
	sudo sed -i "s|Icon=.*$|Icon=firefox|g" "${foxpath[@]}"
	if [[ ! -z $(grep "Icon=firefox" "${foxpath[@]}") ]];
		then
		echo -e "${green}[✔]${endcolor} The Firefox icon has been restored to default" ; sleep 0.2
		echo -e "${yellow}[!]${endcolor} The system might need to be rebooted for changes to take effect" ; sleep 0.2
		else
		echo -e "${red}[!]${endcolor} Failed to restore icon to default" 1>&2 ; sleep 0.2 ; exit 1
	fi	
elif
	[[ $OPTARG == "thunderbird" ]];
	then
	if [ ! -f "${birdpath[@]}" ];
		then
		echo -e "${red}[!]${endcolor} Thunderbird config file missing" 1>&2 ; sleep 0.2 ; exit 1
	fi
	sleep 0.3 ; echo -e "\n${cyan}[-]${endcolor} Restoring Thunderbird icon to default settings..." ; sleep 0.2
	sudo sed -i "s|Icon=.*$|Icon=thunderbird|g" "${birdpath[@]}"	
	if [[ ! -z $(grep "Icon=thunderbird" "${birdpath[@]}") ]];
		then
		echo -e "${green}[✔]${endcolor} The Thunderbird icon has been restored to default" ; sleep 0.2
		echo -e "${yellow}[!]${endcolor} The system might need to be rebooted for changes to take effect" ; sleep 0.2
		else
		echo -e "${red}[!]${endcolor} Failed to restore icon to default" 1>&2 ; sleep 0.2 ; exit 1
	fi
else 
	echo -e "${red}[!]${endcolor} Invalid option! Script requires a ${red}firefox${endcolor} or ${blue}thunderbird${endcolor} argument" 1>&2
	exit 1
fi
}

#Main function that sorts script operations based on the flag arguments provided by the user
main(){
while getopts ":f:t:r:hlR" opt; do
case $opt in
	f)
	if [ ! -f $OPTARG ]; #File path check
		then
		echo -e "${red}[!]${endcolor} Invalid file path! Please provide a correct path" 1>&2 ; exit 1
		else
		if [ ! -f "${foxpath[@]}" ];
			then
			echo -e "${red}[!]${endcolor} Firefox config file missing" 1>&2 ; sleep 0.2 ; exit 1
		fi
		frmt=$(file --mime-type -b $OPTARG) #File type check, in order to make sure it's an image/icon file
		case $frmt in
		image/png|image/jpg|image/jpeg|image/bmp|image/ico)
		echo -e "\n${cyan}[+]${endcolor} Changing Firefox icon..." ; sleep 0.2
		sudo sed -i "s|Icon=.*$|Icon=$OPTARG|g" "${foxpath[@]}"
		if [[ ! -z $(grep "$OPTARG" "${foxpath[@]}") ]];
			then
			echo -e "${green}[✔]${endcolor} The icon path has been changed" ; sleep 0.2
			echo -e "${yellow}[!]${endcolor} The system might need to be rebooted for changes to take effect" ; sleep 0.2
			else
			echo -e "${red}[!]${endcolor} Failed to change icon" 1>&2 ; sleep 0.2 ; exit 1
		fi
		;;
		*) echo -e "${red}[!]${endcolor} Invalid file format! Please provide a different file format" 1>&2 ; exit 1
		;;
		esac
	fi
	;;
	t)
	if [ ! -f $OPTARG ]; #File path check in order to make sure the file exists
		then
		echo -e "${red}[!]${endcolor} Invalid file path! Please provide a correct path" 1>&2 ; exit 1
		else
		if [ ! -f "${birdpath[@]}" ];
			then
			echo -e "${red}[!]${endcolor} Thunderbird config file missing" 1>&2 ; sleep 0.2 ; exit 1
		fi
		frmt=$(file --mime-type -b $OPTARG) #File type check in order to make sure it's an image/icon file
		case $frmt in
		image/png|image/jpg|image/jpeg|image/bmp|image/ico)
		echo -e "\n${cyan}[+]${endcolor} Changing Thunderbird icon..." ; sleep 0.2
		sudo sed -i "s|Icon=.*$|Icon=$OPTARG|g" "${birdpath[@]}"
		if [[ ! -z $(grep "$OPTARG" "${birdpath[@]}") ]];
			then
			echo -e "${green}[✔]${endcolor} The icon path has been changed" ; sleep 0.2
			echo -e "${yellow}[!]${endcolor} The system might need to be rebooted for changes to take effect" ; sleep 0.2
			else
			echo -e "${red}[!]${endcolor} Failed to change icon" 1>&2 ; sleep 0.2 ; exit 1
		fi
		;;
		*) echo -e "${red}[!]${endcolor} Invalid file format! Please provide a different file format" 1>&2 ; exit 1
		;;
		esac
	fi
	;;
	r)
	sleep 0.2 ; rstr	
	;;
	h)
	sleep 0.2 ; usage
	;;
	l)
    if command -v iconchange &>/dev/null;
        then
        echo -e "${red}[!]${endcolor} Symlink already exists" 1>&2 ; exit 1
        else
	    echo -e "\n${cyan}[+]${endcolor} Generating 'iconchange' symlink to command path..." ; sleep 0.2
	    sudo ln -s $(readlink -f $0) /usr/bin/iconchange
	    if command -v iconchange &>/dev/null;
		    then
		    echo -e "${green}[✔]${endcolor} Symlink has been generated successfully" ; sleep 0.2
		    else
		    echo -e "${red}[!]${endcolor} Failed to generate symlink" 1>&2 ; sleep 0.2 ; exit 1
	    fi       
    fi
	;;
	R)
	echo -e "\n${cyan}[-]${endcolor} Removing symlink from command path..." ; sleep 0.2
	sudo unlink /usr/bin/iconchange
	if ! command -v iconchange &>/dev/null;
		then
		echo -e "${green}[✔]${endcolor} Symlink has been successfully removed" ; sleep 0.2
		else
		echo -e "${red}[!]${endcolor} Failed to remove symlink" 1>&2 ; sleep 0.2 ; exit 1
	fi
	;;
	:)
	echo -e "${red}[!]${endcolor} Option -$OPTARG requires an argument" ; 1>&2 ; exit 2
	;;
	\?)
	echo -e "${red}[!]${endcolor} Invalid option!\n" ; sleep 0.2
	echo -e "${green}Usage:${endcolor} ${magenta}${0##*/}${endcolor} [-f argument] [-t argument] [-r argument] [-h] [-l] [-R]" 1>&2
	exit 1
	;;
esac
done
shift $((OPTIND - 1))
}

#Help menu
usage(){
echo -e "\n${blue}Synopsis:${endcolor} Changes the ${red}Firefox${endcolor}/${blue}Thunderbird${endcolor} icons by editing their ${magenta}/usr/share/applications/${endcolor} values."
echo -e "          Capable of restoring the values to default." 
echo -e "          Can generate/remove symlink of script to use script as a terminal command.\n"
echo -e "${green}Usage:${endcolor} ${magenta}${0##*/}${endcolor} [-f argument] [-t argument] [-r argument] [-h] [-l] [-R]"
echo -e "  ${yellow}-f${endcolor} ${cyan}file_path${endcolor}             Firefox icon change"
echo -e "  ${yellow}-h${endcolor}                       Help"
echo -e "  ${yellow}-l${endcolor}                       Generate symlink to /usr/bin/"
echo -e "  ${yellow}-R${endcolor}                       Remove symlink from /usr/bin/"
echo -e "  ${yellow}-r ${cyan}firefox/thunderbird${endcolor}   Restore icon to default"
echo -e "  ${yellow}-t${endcolor} ${cyan}file_path${endcolor}             Tunderbird icon change"
exit
}

#Only allow the script functions to run if the user provides up to two arguments
if [ $# -eq 0 ];
	then
	echo -e "\n${green}Usage:${endcolor} ${magenta}${0##*/}${endcolor} [-f argument] [-t argument] [-r argument] [-h] [-l] [-R]" 1>&2
	exit 2
elif [ $# -ge 3 ];
	then
	echo -e "${red}[!]${endcolor} Invalid option! Too many arguments!" 1>&2 ; exit 1
else	
	main "$@"
fi
