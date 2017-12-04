#!/bin/bash

# Variables to be given to the automatic configuration script
declare -i R=0
declare -i G=255
declare -i B=255
declare -i IsTextWhite=0

# Configure the VM depending on its role in the infrastructure
message "Greetings from VM \"$BASENAME$ID\"!"
message "Paste commands to set the computer appropriately from scratch, depending on its role, here. Eg. disable/enable some services, install packages, etc. Feel free to remove these messages."