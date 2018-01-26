.PHONY: run clean virt-install clean hardclean rmcoreos_production_qemu_image.img

all: readme

run: coreos_production_qemu_image.img coreos1.qcow2 coreos1 coreos1/config .coreos.installed

coreos_production_qemu_image.img:
	wget -c https://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2{,.sig}
	gpg --verify coreos_production_qemu_image.img.bz2.sig
	bunzip2 coreos_production_qemu_image.img.bz2

coreos1.qcow2:
	qemu-img create -f qcow2 -b coreos_production_qemu_image.img coreos1.qcow2

coreos1: coreos1/config

coreos1/config:
	mkdir -p coreos1
	curl -o coreos1/config `cat USER_DATA_URL`

.coreos.installed: coreos1/domain.xml
	virsh define coreos1/domain.xml
	virsh start `cat NAME` 
	echo `date -I`>>.coreos.installed

coreos1/domain.xml:
	$(eval PWD := $(shell pwd))
	virt-install --connect qemu:///system \
		--import \
		--name `cat NAME` \
		--ram 1024 \
		--vcpus 1 \
		--os-type=linux \
		--os-variant=virtio26 \
		--disk path=$(PWD)/coreos1.qcow2,format=qcow2,bus=virtio \
		--network=`cat NETWORK`,`cat MAC` \
		--print-xml > coreos1/domain.xml
	sed -i 's|type="kvm"|type="kvm" xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0"|' "coreos1/domain.xml"
	sed -i "/<\/devices>/a <qemu:commandline>\n  <qemu:arg value='-fw_cfg'/>\n  <qemu:arg value='name=opt/com.coreos/config,file=$(PWD)/coreos1/config'/>\n</qemu:commandline>" "coreos1/domain.xml"

hardclean: rmcoreos_production_qemu_image.img clean

rmcoreos_production_qemu_image.img:
	-rm coreos_production_qemu_image.img

clean:
	-virsh destroy `cat NAME`
	-virsh undefine `cat NAME`
	-rm -Rf coreos1
	-rm coreos1.qcow2
	-rm .coreos.installed

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
