#! /bin/bash -ex


flarectl dns create-or-update --zone appdel.net --type A --name 'appdel.net' --content "$ipaddr"
flarectl dns create-or-update --zone appdel.net --type A --name '*.appdel.net' --content "$ipaddr"
