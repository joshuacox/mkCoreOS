.PHONY: run clean virt-install clean hardclean rmcoreos_production_qemu_image.img

all: readme

run: coreos_production_qemu_image.img coreos1.qcow2 coreos1 coreos1/openstack/latest/user_data .coreos.installed

coreos_production_qemu_image.img:
	wget -c http://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2
	bunzip2 coreos_production_qemu_image.img.bz2

coreos1.qcow2:
	qemu-img create -f qcow2 -b coreos_production_qemu_image.img coreos1.qcow2

coreos1:
	mkdir -p coreos1/openstack/latest

coreos1/openstack/latest/user_data:
	curl -o coreos1/openstack/latest/user_data `cat USER_DATA_URL`

.coreos.installed:
	virt-install --connect qemu:///system --import --name `cat NAME` --ram 1024 --vcpus 1 --os-type=linux --os-variant=virtio26 --disk path=`pwd`/coreos1.qcow2,format=qcow2,bus=virtio --filesystem `pwd`/coreos1/,config-2,type=mount,mode=squash --network=`cat NETWORK`,`cat MAC` --vnc --noautoconsole
	echo `date -I`>>.coreos.installed

hardclean: rmcoreos_production_qemu_image.img clean

rmcoreos_production_qemu_image.img:
	-rm coreos_production_qemu_image.img

clean:
	-virsh destroy `cat NAME`
	-virsh undefine `cat NAME`
	-rm -Rf coreos1
	-rm coreos1.qcow2

rm:
	rm .coreos.installed

.coreos.run: virt-install

readme:
	cat README.md

example:
	cp -i NAME.example NAME
	cp -i NETWORK.example NETWORK
	cp -i MAC.example MAC
	cp -i USER_DATA_URL.example USER_DATA_URL
