### 2 nodes running
##### setup rke on 1
#####   SLE15SP2 started with JeOS
###### to do - use CLOUD image and cloud init
##### logged in as root
#####    register, install needed packages, setup tux user, generate key, fix docker
 ```
 SUSEConnect -r &{REGCODE}
 zypper in wget which sudo docker
 zypper in -t pattern yast2_basis
 yast2 users add username=tux password=linux
 ssh-keygen -b 2048 -t rsa -f /home/tux/.ssh/id_rsa -N “"
 cat /home/tux/.ssh/id_rsa.pub >> /home/tux/.ssh/authorized_keys
 usermod -aG docker tux
```
##### LOGOUT
##### log in as tux
```
sudo systemctl enable —now docker
```

##### test with docker ps
```
docker ps
```

##### firewall config - could do this in yast
##### Open TCP/6443 for all
```
firewall-cmd --zone=public --add-port=6443/tcp --permanent
firewall-cmd --reload
```

##### Open TCP/6443 for one specific IP
```
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="${nodeIP}" port protocol="tcp" port="6443" accept'
firewall-cmd --reload
```

#####    download rke & copy to local path
```
sudo wget -O /usr/local/bin/rke https://github.com/rancher/rke/releases/latest/download/rke_linux-amd64
sudo chmod +x /usr/local/bin/rke
```
####    install kubectl <--specific to 1.18
```
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.18/bin/linux/amd64/kubectl"
mv kubectl /usr/local/bin && chmod +x /usr/local/bin/kubectl
```
#### or install latest kubectl (should be backwards compatible to -3 releases)
```
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
```
#####    install helm3 v3.4.0 <--check https://github.com/helm/helm/releases/latest for the latest release
```
sudo wget -O helm.tar.gz https://get.helm.sh/helm-v3.4.1-linux-amd64.tar.gz
tar -zxvf helm.tar.gz
mv linux-amd64/helm /usr/local/bin && chmod +x helm
 - or -
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```
####    create cluster.yml
```
cat <<EOF> cluster.yml
nodes:
  - address: ${nodeIP}
    user: tux
    role:
      - controlplane
      - etcd
      - worker
EOF
```
##### run rke install
```
rke up --config cluster.yml
```
#### symlink kubeconfig
```
mkdir /home/tux/.kube
ln -s /home/tux/kube_config_rancher-cluster.yml /home/tux/.kube/config
chmod 600 /home/tux/.kube/config
```

#### install cert-manager
```
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager --namespace cert-manager \
  --version v1.0.4 \
  --set installCRDs=true \
  jetstack/cert-manager
```
#### verify rollout
```
kubectl -n cert-manager rollout status deploy/cert-manager-webhook
kubectl -n cert-manager rollout status deploy/cert-manager
```
#### add rancher-latest repo
```
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
```

#### setup ns and install rancher server
```
kubectl create namespace cattle-system
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=<reachable hostname>
  --set replicas=1
```
#### verify it’s ready
```
while true; do curl -kv https://{RancherFQDN} 2>&1 | grep -q "dynamiclistener-ca"; if [ $? != 0 ]; then echo "Rancher isn't ready yet"; sleep 5; continue; fi; break; done; echo "Rancher is Ready”;
```
### Add cluster to Rancher to be managed (workload cluster)
####Login to rancher UI
1. Hover over the top left dropdown, then click Global
2. Click Add Cluster
    * The current context is shown in the upper left, and should say 'Global'
    * Note the multiple types of Kubernetes cluster Rancher supports. We will be using Custom for this lab, but there are a lot of possibilities with Rancher.
3. Click on the From existing nodes (Custom) Cluster box
4. Enter a name in the Cluster Name box
5. Set the Kubernetes Version
6. Click Next at the bottom.
7. Make sure at least 1 ofthe boxes etcd, Control Plane, and Worker are ticked.
8. Click Show advanced options to the bottom right of the Worker checkbox
9. Enter the Public Address () and Internal Address ()
    * IMPORTANT: It is VERY important that you use the correct External and Internal addresses from the Cluster01 machine for this step, and run it on the correct machine. Failure to do this will cause the future steps to fail.
10. Click the clipboard to Copy to Clipboard the docker run command
