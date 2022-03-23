TroubleshootingRancher

Lost your cluster.yml? 
curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
'https://${HOSTNAME}/v3/clusters/${CLUSTER_ID}?action=exportYaml' 

kubectl --kubeconfig kubeconfig_admin.yaml get configmap -n kube-system full-cluster-state -o json | jq -r .data.\"full-cluster-state\" | jq -r .currentState.rkeConfig


Remove unremovable cluster
kubectl get clusters.management.cattle.io  # find the cluster you want to delete 
kubectl patch clusters.management.cattle.io $CLUSTERID -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl delete clusters.management.cattle.io $CLUSTERID