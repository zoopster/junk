

kubectl create ns cfo

helm install cf-operator suse/cf-operator \
  --namespace cfo \
  --set "global.operator.watchNamespace=kubecf" \
  --version 4.5.6+0.gffc6f942

helm install kubecf suse/kubecf \
  --namespace kubecf
  --values kubecf-config-values.yaml
  --version 2.2.2
  --set features.ingress.enabled-true

