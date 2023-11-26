podman run \
-d \
--name frigate \
--privileged \
--restart=unless-stopped \
--mount type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000 \
--device /dev/bus/usb:/dev/bus/usb \
--device /dev/dri/renderD128 \
--shm-size=384m \
-v frigate:/media/frigate \
-v /root/frigate/config.yml:/config/config.yml:ro \
-v /etc/localtime:/etc/localtime:ro \
# -e PLUS-API-KEY="" \
-p 5000:5000 \
-p 1935:1935 \
ghcr.io/blakeblackshear/frigate:stable