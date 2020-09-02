helm install susecf-console suse/console \
  --namespace stratos \
  --values stratos-config-values.yaml
  --set console.techPreview=true

