# playbooks-misc

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Playbooks

| Name                        | Description                                                                                                                                                           |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| k8s-crio-stacked-etcd.yaml  | Install Kubernetes with optional support for multiple masters, backed by CRI-O and etcd stacked on each node (tested on Rocky 8.7 with firewalld and SELinux enabled) |
| podman-rootless-alpine.yaml | Install and configure Podman with rootless support (tested on Alpine 3.17)                                                                                            |