
coreos:
	mkdir coreos; cd coreos
	wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu.sh
	wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu.sh.sig
	wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2
	wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2.sig
	gpg --verify coreos_production_qemu.sh.sig
	gpg --verify coreos_production_qemu_image.img.bz2.sig
	bzip2 -d coreos_production_qemu_image.img.bz2
	chmod +x coreos_production_qemu.sh
