#!/bin/bash

# Don't touch!
export BASENAME="CNA-"

# variables, functions, etc.
export RAM=1024
export EXECUTIONCAP=100
function message {
echo -e "\n\e[7mHOST>\e[27m $1" #($1 is the text to be displayed.)
			 }
export -f message
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

message "Setting scripts and .desktop launcher as executables.."
cd "$DIR/.." && chmod -R +x * && cd

message "Deleting all \"flag files\"..."
for vm in $(seq -w 1 10); do rm -f "/home/student/shared/flag$vm.txt"; done

message "Deleting all VMs that are not running..."
for toremove in $(vboxmanage list vms | cut -d " " -f 1 | sed "s/\"//g"); do vboxmanage unregistervm $toremove --delete ; done

message "Creating 10 VMs from scratch using the available VMDK file..."
for vm in $(seq -w 1 10); do
vboxmanage createvm --name $BASENAME$vm --ostype RedHat_64 --register
vboxmanage modifyvm $BASENAME$vm --memory $RAM --vram 12 --acpi on --ioapic on --cpus 1 --cpuexecutioncap $EXECUTIONCAP --pae on --hwvirtex on --nestedpaging on --snapshotfolder default --clipboard bidirectional --draganddrop bidirectional --usb on --usbehci on --rtcuseutc on --mouse usbtablet --bioslogoimagepath "$DIR/../../splashes/splash$vm.bmp" --bioslogodisplaytime 5000 --biosbootmenu menuonly --nic1 bridged --nicpromisc1 allow-all --bridgeadapter1 enp5s0 --nic2 bridged --nicpromisc2 allow-all --bridgeadapter2 enp4s5 --nic3 bridged --nicpromisc3 allow-all --bridgeadapter3 enp4s6 --nic4 intnet --nicpromisc4 allow-all --intnet4 intnet4 --nic5 intnet --nicpromisc5 allow-all --intnet5 intnet5 --nic6 intnet --nicpromisc6 allow-all --intnet6 intnet6 --nic7 intnet --nicpromisc7 allow-all --intnet7 intnet7 --nic8 intnet --nicpromisc8 allow-all --intnet8 intnet8
message "Setting proper MAC addresses for every NIC of the VM \"$BASENAME$vm\""
for i in $(seq 1 8); do
	vboxmanage modifyvm $BASENAME$vm --macaddress$i "080016060$((i - 1))$vm"
done
vboxmanage storagectl $BASENAME$vm --name "SATA" --add sata --bootable on --portcount 1
vboxmanage storageattach $BASENAME$vm --storagectl "SATA" --mtype immutable --type hdd --device 0 --port 0 --medium /guest/student/LINUX_XII-disk1.vmdk
vboxmanage sharedfolder add $BASENAME$vm --name shared -hostpath /home/student/shared/ -automount
done

message "Reconfiguring each VM, depending on its role in the infrastructure..."
vms_order=(01 02 03 04 05 06 07 08 09 10)
for vm in ${vms_order[*]}; do 
	export vm
	if [[ $(vboxmanage showvminfo "$BASENAME$vm" | grep -c "running (since") -eq 1 ]]; then
	   message "VM $BASENAME$vm is online. Skipping further reconfiguration."
	else
	   "$DIR/host-hw$vm.sh"
	fi
done

wait
message "Most likely every script has done its job and the infrastructure is up by now!"
