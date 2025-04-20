#!/bin/bash -i

# Colours

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
#echo -e "${RED}red text ${NC} normal color"

# Default APT Values
bAptUpdate=true
bAptUpgrade=false
bDnfUpdate=true
bDnfUpgrade=false
bFlatPak=false
bAutoYesPrompts=false
bDownloadFilesOnly=false
selectedListsToInstall="Desktop, Server, Flatpak Desktop, Flatpak Server"

bAptExists=false
bDnfExists=false

# Default package lists
defaultDesktop="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-desktop.txt"
defaultServer="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-server.txt"
defaultFlatpakDesktop="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-flatpak-desktop.txt"
defaultFlatpakServer="https://raw.githubusercontent.com/VinterSolen/squidInstaller/refs/heads/main/packagefiles/install-flatpak-server.txt"

#Enable/Disable lists for install
bDefaultDesktop=false
bDefaultServer=false
bDefaultFlatpakDesktop=false
bDefaultFlatpakServer=false

# Main menu of the installer
# Enables user to make changes before running installer
mainMenu() {

  aptUpdate="APT Update: $(yesNoValue "$bAptUpdate") "
  aptUpgrade="APT Upgrade: $(yesNoValue "$bAptUpgrade")  "
  dnfUpdate="DNF Update: $(yesNoValue "$bDnfUpdate") "
  dnfUpgrade="DNF Upgrade: $(yesNoValue "$bDnfUpgrade")  "

  flatPak="FlatPak: $(yesNoValue "$bFlatPak")"
  #Set output to empty before re-building it
  OUTPUT=""

  clear
  updateInstallListString

  echo -e "################################################################################"

  # Root check
  if [ "$USER" != "root" ]; then
    echo -e "${RED}This script might need to be run as root to install packages${NC}"
  fi

  # Put in values of update/upgrades to reflect toggleable values
  if [ "$bAptExists" = "true" ]; then
    # APT
    OUTPUT="${OUTPUT}(1) $aptUpdate \t (2) $aptUpgrade \n"
  elif [ "$bDnfExists" = "true" ]; then
    # DNF
    OUTPUT="${OUTPUT}(1) $dnfUpdate \t (2) $dnfUpgrade \n"
  fi
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
  read -p "Enter value [p]: " readValue
  readValue=${readValue:-p}

  # When user has entered something, do something here
  case $readValue in
  "q") # Exit script
    exit 0
    ;;

  "p") # Print MainMenu
    mainMenu
    ;;

  "1") # Toggle to run repository updates before installing
    if [ "$bAptExists" = "true" ]; then
      # APT
      bAptUpdate=$([ "$bAptUpdate" = true ] && echo false || echo true)
    elif [ "$bDnfExists" = "true" ]; then
      # DNF
      bDnfUpdate=$([ "$bDnfUpdate" = true ] && echo false || echo true)
    fi
    mainMenu
    ;;

  "2") # Toggle to run system upgrade before install
    # bAptUpgrade=$([ "$bAptUpgrade" = true ] && echo false || echo true)
    if [ "$bAptExists" = "true" ]; then
      # APT
      bAptUpgrade=$([ "$bAptUpgrade" = true ] && echo false || echo true)
    elif [ "$bDnfExists" = "true" ]; then
      # DNF
      bDnfUpgrade=$([ "$bDnfUpgrade" = true ] && echo false || echo true)
    fi
    mainMenu
    ;;

  "3") # Toggle to install flatpak, and enable flatpak lists
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
  read -p "Enter value [p]: " readValue
  readValue=${readValue:-p}

  # When the user has entered something, do something here
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
  read -p "Enter value [p]: " readValue
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
      selectedListsToInstall="${GREEN}Server${NC}"
      bFirst=false
    else
      selectedListsToInstall="$selectedListsToInstall, ${GREEN}Server${NC}"
    fi
  fi

  # Desktop
  if [ "$bDefaultDesktop" = "true" ]; then
    if [ "$bFirst" = "true" ]; then
      selectedListsToInstall="${GREEN}Desktop${NC}"
      bFirst=false
    else
      selectedListsToInstall="$selectedListsToInstall, ${GREEN}Desktop${NC}"
    fi
  fi

  # Server, Flatpak
  if [ "$bDefaultFlatpakServer" = "true" ] && [ "$bFlatPak" = "true" ]; then
    if [ "$bFirst" = "true" ]; then
      selectedListsToInstall="${GREEN}Server Flatpak${NC}"
      bFirst=false
    else
      selectedListsToInstall="$selectedListsToInstall, ${GREEN}Server Flatpak${NC}"
    fi
  fi

  # Desktop, Flatpak
  if [ "$bDefaultFlatpakDesktop" = "true" ] && [ "$bFlatPak" = "true" ]; then
    if [ "$bFirst" = "true" ]; then
      selectedListsToInstall="${GREEN}Desktop Flatpak${NC}"
      bFirst=false
    else
      selectedListsToInstall="$selectedListsToInstall, ${GREEN}Desktop Flatpak${NC}"
    fi
  fi

  if [ "$selectedListsToInstall" = "" ]; then
    selectedListsToInstall="${RED}(none)${NC}"
  fi
}

checkDNForAPT() {
  if available apt-get; then
    bAptExists=true
  else
    bAptExists=false
  fi

#  if ! [ -x "$(command -v dnf)" ]; then
  if available dnf; then
    bDnfExists=true
  else
    bDnfExists=falseq

  fi
}

# Helpers
available() { command -v "${1:?}" >/dev/null; }


# Check if DNF or APT exists on the system
checkDNForAPT

# Calls the mainMenu function to start off the script
mainMenu
