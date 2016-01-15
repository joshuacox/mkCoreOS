.PHONY: run clean virt-install clean hardclean rmcoreos_production_qemu_image.img

all: readme

run: coreos_production_qemu_image.img coreos1.qcow2 coreos1 coreos1/openstack/latest/user_data .coreos.run

coreos_production_qemu_image.img:
	wget -c http://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2
	bunzip2 coreos_production_qemu_image.img.bz2

coreos1.qcow2:
	qemu-img create -f qcow2 -b coreos_production_qemu_image.img coreos1.qcow2

coreos1:
	mkdir -p coreos1/openstack/latest

coreos1/openstack/latest/user_data:
	curl -o coreos1/openstack/latest/user_data `cat USER_DATA_URL`

virt-install:
	virt-install --connect qemu:///system --import --name coreos1 --ram 1024 --vcpus 1 --os-type=linux --os-variant=virtio26 --disk path=`pwd`/coreos1.qcow2,format=qcow2,bus=virtio --filesystem `pwd`/coreos1/,config-2,type=mount,mode=squash --network=`cat NETWORK`,`cat MAC` --vnc --noautoconsole

hardclean: rmcoreos_production_qemu_image.img clean

rmcoreos_production_qemu_image.img:
	-rm coreos_production_qemu_image.img

clean:
	-rm -Rf coreos1
	-rm coreos1.qcow2

.coreos.run: virt-install

readme:
	cat README.md

example:
	cp NETWORK.example NETWORK
	cp MAC.example MAC
	cp USER_DATA_URL.example USER_DATA_URL
