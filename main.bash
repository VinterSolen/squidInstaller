#!/bin/bash

# Default APT Values
bAptUpdate=true
bAptUpgrade=false
bFlatPak=false



# Default package lists
defaultDesktop="https://github.com/VinterSolen/squidInstaller/blob/main/packagefiles/install-desktop.txt"
defaultServer="https://github.com/VinterSolen/squidInstaller/blob/main/packagefiles/install-server.txt"


# Main menu of the installer
# Enables user to make changes before running installer
mainMenu() {

aptUpdate="APT Update: $(yesNoValue "$bAptUpdate") "
aptUpgrade="APT Upgrade: $(yesNoValue "$bAptUpgrade")  "
flatPak="FlatPak: $(yesNoValue "$bFlatPak")"
#Set output to empty before re-building it
OUTPUT=""
clear

echo -e "################################################################################"
# Put in values of update/upgrades to reflect toggleable values
OUTPUT="${OUTPUT}(1) $aptUpdate \t (2) $aptUpgrade \n"
OUTPUT="${OUTPUT}(3) $flatPak \t (4) Default lists \n"



# Last Rows
OUTPUT="${OUTPUT}(r) Run installer \t\n"
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

  *) # If no other value matches
    mainMenu
    ;;
esac


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

# Calls the mainMenu function to start off the script
mainMenu