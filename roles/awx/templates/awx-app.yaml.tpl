{% if not awx_use_local_storage %}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: smb-credentials
  namespace: awx
data:
  username: {{awx_smb_username | b64encode}}
  password: {{awx_smb_password | b64encode}}
---
{% endif %}
apiVersion: v1
kind: Secret
metadata:
  name: awx-app-admin-password
  namespace: awx
stringData:
  password: {{awx_admin_default_password}}
---
apiVersion: v1
kind: Secret
metadata:
  name: awx-app-postgres-configuration
  namespace: awx
stringData:
  type: managed
  host: awx-app-postgres-13
  port: "5432"
  database: awx
  username: {{awx_database_username}}
  password: {{awx_database_password}}
---
{% if not awx_use_local_storage %}
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-pgsql
provisioner: smb.csi.k8s.io
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
parameters:
  source: {{awx_smb_sql_path}}
  csi.storage.k8s.io/provisioner-secret-name: "smb-credentials"
  csi.storage.k8s.io/provisioner-secret-namespace: "awx"
  csi.storage.k8s.io/node-stage-secret-name: "smb-credentials"
  csi.storage.k8s.io/node-stage-secret-namespace: "awx"
mountOptions:
  - dir_mode=0700
  - file_mode=0700
  - uid=999
  - gid=999
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage-projects
provisioner: smb.csi.k8s.io
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
parameters:
  source: {{awx_smb_projects_path}}
  csi.storage.k8s.io/provisioner-secret-name: "smb-credentials"
  csi.storage.k8s.io/provisioner-secret-namespace: "awx"
  csi.storage.k8s.io/node-stage-secret-name: "smb-credentials"
  csi.storage.k8s.io/node-stage-secret-namespace: "awx"
mountOptions:
  - dir_mode=0770
  - file_mode=0770
  - uid=1000
  - gid=0
---
{% endif %}
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-app
spec:
  service_type: nodeport
  nodeport_port: {{awx_nodeport}}
  ingress_type: ingress
  projects_persistence: true
  projects_storage_access_mode: {{ "ReadWriteOnce" if awx_use_local_storage else "ReadWriteMany"}}
  projects_storage_class: {{ "local-path" if awx_use_local_storage else "local-storage-projects"}}
  postgres_storage_class: {{ "local-path" if awx_use_local_storage else "local-storage-pgsql"}}