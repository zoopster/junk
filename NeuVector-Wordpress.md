Let's use a [RKE2](https://rke2.io/) Kubernetes cluster. K3s is also an option. Simply substitute the same commands for the k3s download site (get.k3s.io)

sudo bash -c 'curl -sfL https://get.rke2.io | \
  INSTALL_RKE2_CHANNEL="v1.22" \
  sh -'

Create a configuration for RKE2

sudo mkdir -p /etc/rancher/rke2
sudo bash -c 'echo "write-kubeconfig-mode: \"0644\"" > /etc/rancher/rke2/config.yaml'

Enable and start the RKE2 systemd service:

sudo systemctl enable --now rke2-server.service

Follow the logs with
sudo journalctl -u rke2-server -f

Install NeuVector with helm
Download helm if it's not installed already
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
  | bash

Verify what you installed
helm version --client --short

Verify access to your cluster
helm ls --all-namespaces

Install cert-manager for a valid cert
Add the Jetstack helm repository
helm repo add jetstack https://charts.jetstack.io

Install cert-manager version `1.7.1`
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.7.1 \
  --set installCRDs=true \
  --create-namespace

Watch the rollout
kubectl -n cert-manager rollout status deploy/cert-manager
kubectl -n cert-manager rollout status deploy/cert-manager-webhook

Add NeuVector helm repository
helm repo add neuvector https://neuvector.github.io/neuvector-helm/

Create a ClusterIssuer object for the TLS cert

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
spec:
  selfSigned: {}
EOF
  
Create the values file for the NeuVector helm install
cat <<EOF > ~/neuvector-values.yaml
k3s:
  enabled: true
controller:
  replicas: 1
cve:
  scanner:
    replicas: 1
manager:
  ingress:
    enabled: true
    host: neuvector.${vminfo:kubernetes01:public_ip}.sslip.io
    annotations:
      cert-manager.io/cluster-issuer: selfsigned-cluster-issuer
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    tls: true
    secretName: neuvector-tls-secret
EOF

Install NeuVector with helm

helm install neuvector neuvector/core \
  --namespace cattle-neuvector-system \
  -f ~/neuvector-values.yaml \
  --version 2.2.0 \
  --create-namespace

Be patient as it starts up
kubectl get pods -n cattle-neuvector-system

Then access NeuVector at "https://neuvector.${nodeIP}.sslip.io"
Bypass the cert warning
Log in with the username "admin" and the default password "admin"
Agree to the Terms & Conditions

Deploy Wordpress into the cluster.

Note, that this Wordpress is not highly available and is not configured with persistent storage. You should not run this Helm chart in production.

First, we'll add the helm repository for Wordpress
helm repo add rodeo https://rancher.github.io/rodeo

Install wordpress
Be sure to change the hostname to your public IP or FQDN
helm install \
  wordpress rodeo/wordpress \
  --namespace wordpress \
  --set wordpress.ingress.hostname=wordpress.${nodeIP}.sslip.io \
  --create-namespace

Give the pods a few to start
kubectl get pods -n wordpress

Verify access to Wordpress at "http://wordpress.${nodeIP}.sslip.io"

