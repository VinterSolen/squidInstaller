#!/bin/bash

# Default APT Values
bAptUpdate=true
bAptUpgrade=false


# Main menu of the installer
# Enables user to make changes before running installer
mainMenu() {

aptUpdate="APT Update: $bAptUpdate "
aptUpgrade="APT Upgrade: $bAptUpgrade "

#Set output to empty before re-building it
OUTPUT=""
clear

echo -e "################################################################################"
# Put in values of update/upgrades to reflect toggleable values
OUTPUT="${OUTPUT} (1) $aptUpdate \t (2) $aptUpgrade \n"



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

  *) # If no other value matches
    mainMenu
    ;;
esac


}

# Calls the mainMenu function to start off the script
mainMenu