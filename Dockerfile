# From the image we activated
FROM registry.suse.com/suse/sle15:latest
# FROM quay.io/prometheus/busybox:latest
MAINTAINER John Pugh <pepelepugh@gmail.com>

#Refresh services and repositories
RUN zypper ref -s

#Refresh again
RUN zypper refs && zypper refresh

COPY prometheus /bin/prometheus
COPY promtool /bin/promtool
COPY documentation/examples/prometheus.yml /etc/prometheus/prometheus.yml
COPY console_libraries/ /etc/prometheus/
COPY consoles/ /etc/prometheus/

EXPOSE 9090
VOLUME [ "/prometheus" ]
WORKDIR /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD [ "-config.file=/etc/prometheus/prometheus.yml", \
"-storage.local.path=/prometheus", \
"-web.console.libraries=/etc/prometheus/console_libraries", \
"-web.console.templates=/etc/prometheus/consoles" ]




#Install nginx non-interactive
#RUN zypper -n in nginx

#Put this statement to prevent nginx from running as a daemon
#RUN echo “daemon off; >> /etc/nginx/nginx.conf

#Expose port 80
#EXPOSE 80

#Run NGINX
#CMD [“nginx”]
