virt-install -n worldco-rancher --memory 4096 --vcpus 2 --cdrom ~/Downloads/SLE-Micro-5.4-DVD-x86_64-GM-Media1.iso --disk rancher.qcow2,size=60 --network network=default,mac.address=2A:C3:A7
:A7:00:03 --graphics vnc --boot uefi --os-variant slem5.4