#!/bin/bash

for ((;;)); do
	if [ -e "/media/sf_shared/adminsk/scripts/guest/vm-automatic_configuration.sh" ]; then
		# Grabbing the "message" function
		source <(sed -n ''"2"',$p;'"10"'q' "/media/sf_shared/adminsk/scripts/guest/vm-automatic_configuration.sh")
		message "Bingo! Guest Additions work in the VM \"$BASENAME$vm\"! Now moving on to file operations..."
		break
	fi
	sleep 1
done
bash "/media/sf_shared/adminsk/scripts/guest/vm-automatic_configuration.sh"
