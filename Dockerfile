# From the image we activated
FROM registry.suse.com/suse/sle15:latest
# FROM quay.io/prometheus/busybox:latest

#Refresh services and repositories
RUN zypper ref -s

#Refresh again
RUN zypper refs && zypper refresh

RUN useradd -m prometheus
# RUN groupadd
mkdir /srv/prometheus

USER prometheus
COPY prometheus/ /srv/prometheus
COPY node_exporter/ /srv/prometheus
COPY alertmanager/ /srv/prometheus
# COPY promtool promtool
# COPY documentation/examples/prometheus.yml /etc/prometheus/prometheus.yml
# COPY console_libraries/ prometheus/console_libraries
# COPY consoles/ prometheus/consoles

EXPOSE 9090
#VOLUME [ "/prometheus" ]
WORKDIR /srv/prometheus
ENTRYPOINT [ "prometheus" ]
#CMD [ "-config.file=prometheus/prometheus.yml", \
#"-storage.local.path=/prometheus", \
#"-web.console.libraries=prometheus/console_libraries", \
#"-web.console.templates=prometheus/consoles" ]
