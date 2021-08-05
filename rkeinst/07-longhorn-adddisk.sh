#! /bin/bash -ex

pvcreate /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
vgcreate vg_longhorn /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
lvcreate -n vg_longhorn/lv_longhorn -l100%FREE
mkfs.xfs /dev/vg_longhorn/lv_longhorn
mkdir /var/lib/longhorn
echo "/dev/vg_longhorn/lv_longhorn /var/lib/longhorn xfs defaults 0 0" >>/etc/fstab
mount /var/lib/longhorn
