#!/bin/bash

cd /home/student/shared
rm -f "flag$vm.txt"
vboxmanage startvm "$BASENAME$vm"

# Allow the guest to create a file named "flag$ID.txt" and allow host to keep on checking, whether the file exists. If it does, then we are sure that Guest Additions are running just fine. Otherwise the guest wouldn't have created the file. We are sure the guest has warmed up by now and is ready for further actions.
for ((;;)); do
	2>/dev/null vboxmanage guestcontrol "$BASENAME$vm" --username kurs --password kursLA run --exe "/usr/bin/touch" -- - "/media/sf_shared/flag$vm.txt"
	if [ -e "flag$vm.txt" ]; then
		message "Bingo! Guest Additions work in the VM \"$BASENAME$vm\"! Now moving on to file operations..."
		break
	fi
	sleep 1
done

# So now it is time for more tweaks: remove the default launcher, which just opens a terminal with 4 tabs, paste mine, which will execute startup scripts from the guest and sync filesystems before a forced reset.
message "Onto startup tweaks for the VM \"$BASENAME$vm\"..."
vboxmanage guestcontrol "$BASENAME$vm" --username kurs --password kursLA run --exe "/bin/rm" -- -f "/home/kurs/.config/autostart/Terminal x4.desktop"
vboxmanage guestcontrol "$BASENAME$vm" --username kurs --password kursLA run --exe "/bin/cp" -- - "/media/sf_shared/adminsk/scripts/guest/vm-startup.desktop" "/home/kurs/.config/autostart/"
vboxmanage guestcontrol "$BASENAME$vm" --username kurs --password kursLA run --exe "/bin/cp" -- - "/media/sf_shared/adminsk/scripts/guest/vm-watch_for_vboxga.sh" "/home/kurs/.config/autostart/"
vboxmanage guestcontrol "$BASENAME$vm" --username kurs --password kursLA run --exe "/usr/bin/sync"
message "Forcing a reset for $BASENAME$vm !"
vboxmanage controlvm "$BASENAME$vm" reset

