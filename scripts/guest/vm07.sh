#!/bin/bash

# Variables to be given to the automatic configuration script
declare -i R=64
declare -i G=0
declare -i B=0
declare -i IsTextWhite=1

# Configure the VM depending on its role in the infrastructure
message "Greetings from VM \"$BASENAME$ID\"!"
message "Paste commands to set the computer appropriately from scratch, depending on its role, here. Eg. disable/enable some services, install packages, etc. Feel free to remove these messages."