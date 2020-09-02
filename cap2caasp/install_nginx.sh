helm install stable/nginx-ingress \
	--name ingress \
	--namespace ingress \
	--set "tcp.2222=kube/scheduler:2222" \
	--set "tcp." \
	--set "tcp." \

