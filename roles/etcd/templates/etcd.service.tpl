[Unit]
Description=etcd
After=network.target

[Service]
Type=notify
ExecStart={{etcd_install_path}}/etcd --name {{ansible_hostname}} --data-dir {{etcd_data_path}} --listen-client-urls "http://{{ansible_default_ipv4.address}}:2379,http://127.0.0.1:2379" --advertise-client-urls "http://{{ansible_default_ipv4.address}}:2379" --listen-peer-urls "http://{{ansible_default_ipv4.address}}:2380" --initial-advertise-peer-urls "http://{{ansible_default_ipv4.address}}:2380" --initial-cluster "{{etcd_cluster}}" --heartbeat-interval {{etcd_heartbeat_interval}} --election-timeout {{etcd_election_timeout}}
Restart=always
RestartSec=5
TimeoutStartSec=0
StartLimitInterval=0

[Install]
WantedBy=multi-user.target