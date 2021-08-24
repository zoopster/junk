#Install & configure dnsmasq on mac for Rancher-Desktop

brew install dnsmasq
make copy of default config 
    cp /usr/local/etc/dnsmasq.conf /usr/local/etc/dnsmasq.conf.orig 

include all of the files in a directory ending in .conf
    vi /usr/local/etc/dnsmasq.conf 
    uncomment #/conf-dir=/usr/local/etc/dnsmasq.d/,*.conf (near the bottom of the massive file)

create /usr/local/etc/dnsmasq.d/<somename>.conf
    add entry - 

sudo mkdir -p /etc/resolver
create a file called /etc/resolver/rancher.test
    nameserver 127.0.0.1

sudo brew services start dnsmasq
test with dig rancher.test +short

