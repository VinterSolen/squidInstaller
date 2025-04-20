#!/bin/bash

bAptUpdate=true
bAptUpgrade=false

#OUTPUT="$(ls -al   )"
#ls -al   | column -t -o "    "
mainMenu() {


aptUpdate="APT Update: $bAptUpdate "
aptUpgrade="APT Upgrade: $bAptUpgrade "


OUTPUT=""
clear
echo -e "################################################################################"
OUTPUT="${OUTPUT} (1) $aptUpdate \t (2) $aptUpgrade \n"



#Last Row
OUTPUT="${OUTPUT}(r) Run installer \t\n"

OUTPUT="${OUTPUT}(p) Print Menu \t (q) Exit \n"


#echo -e $aptUpdate
echo -e $OUTPUT | column -ts $'\t' -o "  "
echo -e "################################################################################"

read   -p "Enter value [p]: " readValue
readValue=${readValue:-p}

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

  *)
    mainMenu
    ;;
esac


}

mainMenu