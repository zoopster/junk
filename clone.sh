#!/bin/bash
# usage: clone.sh [source_domain] target_domain [target_domain_2 ...]
# note - if you want to make more than one clone, you must specify the source.
#clone.sh origname targetprefix-{domain1,domain2{1,2},d3{1,2}} <--makes 5 machines
set -o errexit

SRC=sle15sp1
if (( ${#@} > 1 ))
then
  SRC="$1"
  shift
fi
if (( ${#@} > 1 ))
then
  for D in "$@"
  do
    "$0" "$SRC" "$D"
  done
  exit
fi
DST="${1:?usage: $0 newname}"

src_disk=$( virsh dumpxml "$SRC" \
  | xmlstarlet sel -t -v "/domain/devices/disk[@device='disk']/source/@file"
  )
disk_path=$( dirname "$src_disk" )
dst_disk="$disk_path/$DST.qcow2"


# generate the XML before creating the disk image, because virt-clone
# gripes about an existing disk even if you're just dumping the XML :/
clone_xml=$( 
  virt-clone --original "$SRC" --name "$DST" --file "$dst_disk" --print-xml
  )

# now create the new disk image
qemu-img create -f qcow2 -b "$src_disk" "$dst_disk"

# create a new VM using the clone XML
virsh define --validate --file <( cat <<<"$clone_xml" )

# reset the hostname and such on the new VM
virt-sysprep --domain "$DST" --hostname "$DST"
