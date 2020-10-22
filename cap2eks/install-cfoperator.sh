

kubectl create ns cfo

helm install cf-operator suse/cf-operator \
  --namespace cfo \
  --set "global.operator.watchNamespace=kubecf" \

helm install kubecf suse/kubecf \
  --namespace kubecf \
  --values kubecf-config-values.yaml \
  --version 2.5.8
