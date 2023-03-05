apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: "v{{k8s_version}}"
{% if k8s_control_plane_endpoint %}
controlPlaneEndpoint: "{{k8s_control_plane_endpoint}}"
{% endif %}
{% if k8s_extra_cert_sans | length %}
apiServer:
  certSANs:
{% for k8s_extra_cert_san in k8s_extra_cert_sans %}
    - "{{k8s_extra_cert_san}}"
{% endfor %}
{% endif %}
etcd:
  external:
    endpoints:
{% for host in groups['etcd'] %}
      - http://{{hostvars[host].ansible_default_ipv4.address}}:2379
{% endfor %}
networking:
  podSubnet: "{{k8s_pod_subnet}}"