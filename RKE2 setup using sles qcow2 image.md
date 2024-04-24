RKE2 setup using sles qcow2 image

assumes KVM/libvirt using VMM

setup a new vm in UI
use sles qcow2 image

start image...go through 1st boot
change hostname
hostnamectl hostname <name>

disable firewall
systemctl disable --now firewalld.service

register with scc
SUSEConnect -r <code>

reboot

install rke2
curl -sfL https://get.rke2.io |sh -

start the service
systemctl enable --now rke2-server.service

setup kubectl access however you wish

install cert-manager
helm install cert-manager jetstack/cert-manager \
--namespace=cert-manager \
--create-namespace \
--version=1.11.0 \
--set installCRDs=true


rancher install
helm install rancher rancher/rancher \
--namespace=cattle-system \
--create-namespace \
--set hostname=some.host.name \ 
--set replicas=1 \
--set bootstrapPassword=somepassword \
--set global.cattle.psp.enabled=false

wait...