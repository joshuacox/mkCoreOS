.PHONY: run clean virt-install

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
	virt-install --connect qemu:///system --import --name coreos1 --ram 1024 --vcpus 1 --os-type=linux --os-variant=virtio26 --disk path=`pwd`/coreos1.qcow2,format=qcow2,bus=virtio --filesystem `pwd`/coreos1/,config-2,type=mount,mode=squash --network bridge=virbr0,mac=52:54:00:fe:b3:c0,type=bridge --vnc --noautoconsole

clean:
	-rm coreos_production_qemu_image.img
	-rm -Rf coreos1
	-rm coreos1.qcow2

.coreos.run: virt-install
