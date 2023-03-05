apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - github.com/ansible/awx-operator/config/default?ref={{awx_version}}
  #- awx-app.yaml
images:
  - name: quay.io/ansible/awx-operator
    newTag: {{awx_version}}
namespace: awx