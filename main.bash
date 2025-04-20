#!/bin/bash

# Colours
RED='\033[0;31m'
NC='\033[0m' # No Color
#echo -e "${RED}red text ${NC} normal color"

# Default APT Values
bAptUpdate=true
bAptUpgrade=false
bFlatPak=false
bAutoYesPrompts=false
bDownloadFilesOnly=false
selectedListsToInstall="Desktop, Server, Flatpak Desktop, Flatpak Server"


# Default package lists
defaultDesktop="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-desktop.txt"
defaultServer="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-server.txt"
defaultFlatpakDesktop="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-flatpak-desktop.txt"
defaultFlatpakServer="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-flatpak-server.txt"

#Enable/Disable lists for install
bDefaultDesktop=true
bDefaultServer=true
bDefaultFlatpakDesktop=true
bDefaultFlatpakServer=true




# Main menu of the installer
# Enables user to make changes before running installer
mainMenu() {



aptUpdate="APT Update: $(yesNoValue "$bAptUpdate") "
aptUpgrade="APT Upgrade: $(yesNoValue "$bAptUpgrade")  "
flatPak="FlatPak: $(yesNoValue "$bFlatPak")"
#Set output to empty before re-building it
OUTPUT=""


clear
updateInstallListString

echo -e "################################################################################"

# Root check
if [ "$USER" != "root" ]; then
    echo -e "${RED}This script needs to be run as root to install packages${NC}"
fi

# Put in values of update/upgrades to reflect toggleable values
OUTPUT="${OUTPUT}(1) $aptUpdate \t (2) $aptUpgrade \n"
OUTPUT="${OUTPUT}(3) $flatPak \t (4) Show lists \n"



# Last Rows
OUTPUT="${OUTPUT}(r) Run installer \t (a) Automatic yes to prompts: $(yesNoValue "$bAutoYesPrompts")\n"
OUTPUT="${OUTPUT}\t (d) Download files only: $(yesNoValue "$bDownloadFilesOnly")\n"
OUTPUT="${OUTPUT}(e) Lists to install:\t $selectedListsToInstall \n"
OUTPUT="${OUTPUT}(p) Print Menu \t (q) Exit \n"


# Print the menu and format the columns a bit nicer to view
echo -e $OUTPUT | column -ts $'\t' -o "  "
echo -e "################################################################################"

# Read input for options, p to reprint the menu as default value
read   -p "Enter value [p]: " readValue
readValue=${readValue:-p}

# When user has entered something, do something here
case $readValue in
  "q")
    exit 0
    ;;

  "p")
    mainMenu
    ;;

  "1")
  bAptUpdate=$([ "$bAptUpdate" = true ] && echo false || echo true)
  mainMenu
  ;;

  "2")
  bAptUpgrade=$([ "$bAptUpgrade" = true ] && echo false || echo true)
  mainMenu
  ;;

  "3")
  bFlatPak=$([ "$bFlatPak" = true ] && echo false || echo true)
  mainMenu
  ;;

  "4")
  defaultListMenu
  ;;

  "a") # Answer yes to all prompts
  bAutoYesPrompts=$([ "$bAutoYesPrompts" = true ] && echo false || echo true)
  mainMenu
  ;;

  "d") # Only download the files without installing
  bDownloadFilesOnly=$([ "$bDownloadFilesOnly" = true ] && echo false || echo true)
  mainMenu
  ;;

  "e") # Change what lists to be installed
  changeInstallLists
  ;;


  *) # If no other value matches
    mainMenu
    ;;
esac


}


changeInstallLists() {
OUTPUT=""
clear

echo -e "################################################################################"



OUTPUT="${OUTPUT}(1) Server list \t $(yesNoValue "$bDefaultServer") \n"
OUTPUT="${OUTPUT}(2) Desktop list \t $(yesNoValue "$bDefaultDesktop") \n"
OUTPUT="${OUTPUT}(3) Flatpak list (Server) \t $(yesNoValue "$bDefaultFlatpakServer") \n"
OUTPUT="${OUTPUT}(4) Flatpak list (Desktop) \t $(yesNoValue "$bDefaultFlatpakDesktop") \n"
OUTPUT="${OUTPUT}(d) Display lists content \t  \n"


# Last Rows
OUTPUT="${OUTPUT}(m) Main menu \t\n"
OUTPUT="${OUTPUT}(p) Print Menu \t (q) Exit \n"


# Print the menu and format the columns a bit nicer to view
echo -e $OUTPUT | column -ts $'\t' -o "  "
echo -e "################################################################################"

# Read input for options, p to reprint the menu as default value
read   -p "Enter value [p]: " readValue
readValue=${readValue:-p}


# When user has entered something, do something here
case $readValue in
  "q")
    exit 0
    ;;

  "p")
    changeInstallLists
    ;;

  "1")
  bDefaultServer=$([ "$bDefaultServer" = true ] && echo false || echo true)
  changeInstallLists
  ;;

  "2")
  bDefaultDesktop=$([ "$bDefaultDesktop" = true ] && echo false || echo true)
  changeInstallLists
  ;;

  "3")
  bDefaultFlatpakServer=$([ "$bDefaultFlatpakServer" = true ] && echo false || echo true)
  changeInstallLists
  ;;

  "4")
  bDefaultFlatpakDesktop=$([ "$bDefaultFlatpakDesktop" = true ] && echo false || echo true)
  changeInstallLists
  ;;


  "d")
  displayListContent
  changeInstallLists
  ;;

  "m")
  updateInstallListString
  mainMenu
  ;;

  *) # If no other value matches
    changeInstallLists
    ;;
esac
}

# Function to displays and enables changing the default lists

defaultListMenu() {
#Set output to empty before re-building it
OUTPUT=""
clear

echo -e "################################################################################"
# Put in values of update/upgrades to reflect toggleable values
OUTPUT="${OUTPUT}(1) Server list \t $defaultServer \n"
OUTPUT="${OUTPUT}(2) Desktop list \t $defaultDesktop \n"
OUTPUT="${OUTPUT}(3) Flatpak list (Server) \t $defaultFlatpakDesktop \n"
OUTPUT="${OUTPUT}(4) Flatpak list (Desktop) \t $defaultFlatpakServer \n"
OUTPUT="${OUTPUT}(d) Display lists content \t  \n"

# Last Rows
OUTPUT="${OUTPUT}(m) Main menu \t\n"
OUTPUT="${OUTPUT}(p) Print Menu \t (q) Exit \n"


# Print the menu and format the columns a bit nicer to view
echo -e $OUTPUT | column -ts $'\t' -o "  "
echo -e "################################################################################"

# Read input for options, p to reprint the menu as default value
read   -p "Enter value [p]: " readValue
readValue=${readValue:-p}


# When user has entered something, do something here
case $readValue in
  "q")
    exit 0
    ;;

  "p")
    defaultListMenu
    ;;

  "1")
  #bAptUpdate=$([ "$bAptUpdate" = true ] && echo false || echo true)
  defaultListMenu
  ;;

  "2")
  #bAptUpgrade=$([ "$bAptUpgrade" = true ] && echo false || echo true)
  defaultListMenu
  ;;

  "3")
  #bFlatPak=$([ "$bFlatPak" = true ] && echo false || echo true)
  defaultListMenu
  ;;

  "4")
  defaultListMenu
  ;;

  "d")
  displayListContent
  defaultListMenu
  ;;

  "m")
  mainMenu
  ;;

  *) # If no other value matches
    defaultListMenu
    ;;
esac

}

# Fetches the lists and displays them for the user
displayListContent() {
  echo "Fetching lists.."
  #$defaultServer
  contentdefaultServer=$(wget $defaultServer -q -O -)
  contentdefaultDesktop=$(wget $defaultDesktop -q -O -)
  contentdefaultFlatpakDesktop=$(wget $defaultFlatpakDesktop -q -O -)
  contentdefaultFlatpakServer=$(wget $defaultFlatpakServer -q -O -)
  #content=$(wget google.com -q -O -)

echo -e "#############################\n"
echo "Candidates for Server:"
echo $contentdefaultServer
echo -e "#############################\n"
echo "Candidates for Desktop:"
echo $contentdefaultDesktop
echo -e "#############################\n"
echo "Candidates for Flatpak Server:"
echo $contentdefaultFlatpakServer
echo -e "#############################\n"
echo "Candidates for Flatpak Desktop:"
echo -e $contentdefaultFlatpakDesktop
echo "#############################"



# Script continues after user presses Enter
pause_for_user




}

# Pauses script execution until user presses Enter
# Optional prompt message can be provided as argument
pause_for_user() {
    read -n 1 -s -r -p "Press any key to continue"
}


# Function that converts truthy/falsy values to "yes" or "no"
# Usage: yesNoValue <input>
# Returns "yes" if input is 1 or true, "no" if input is 0 or false
yesNoValue() {
    local input=$1

    # Convert a string to lowercase
    to_lowercase() {
        local input="$1"
        echo "$input" | tr '[:upper:]' '[:lower:]'
    }

    input_lower=$(to_lowercase "$input")

    if [ "$input_lower" = "1" ] || [ "$input_lower" = "true" ]; then
        echo "Yes"
    elif [ "$input_lower" = "0" ] || [ "$input_lower" = "false" ]; then
        echo "No"
    else
        # Optional: handle invalid input - you can change this behavior
        echo "invalid input"
    fi
}


updateInstallListString() {

  selectedListsToInstall=""
  local bFirst=true


    # Server
    if [ "$bDefaultServer" = "true" ]; then
      if [ "$bFirst" = "true" ]; then
        selectedListsToInstall="Server"
        bFirst=false
     else
        selectedListsToInstall="$selectedListsToInstall, Server"
      fi
    fi

  # Desktop
    if [ "$bDefaultDesktop" = "true" ]; then
      if [ "$bFirst" = "true" ]; then
        selectedListsToInstall="Desktop"
        bFirst=false
     else
        selectedListsToInstall="$selectedListsToInstall, Desktop"
      fi
    fi

  # Server, Flatpak
    if [ "$bDefaultFlatpakServer" = "true" ]; then
      if [ "$bFirst" = "true" ]; then
        selectedListsToInstall="Server Flatpak"
        bFirst=false
     else
        selectedListsToInstall="$selectedListsToInstall, Server Flatpak"
      fi
    fi

  # Desktop, Flatpak
    if [ "$bDefaultFlatpakDesktop" = "true" ]; then
      if [ "$bFirst" = "true" ]; then
        selectedListsToInstall="Desktop Flatpak"
        bFirst=false
     else
        selectedListsToInstall="$selectedListsToInstall, Desktop Flatpak"
      fi
    fi

if [ "$selectedListsToInstall" = "" ]; then
    selectedListsToInstall="(none)"
fi

  #selectedListsToInstall="Desktop, Server, Flatpak Desktop, Flatpak Server"

}


# Calls the mainMenu function to start off the script
mainMenu