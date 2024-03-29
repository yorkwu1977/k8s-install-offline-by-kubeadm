#!/bin/sh

# 说明：安装K8s时会用到的私有镜像库
# 执行范围：所有主机

# 为Docker配置私有源

cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries":["harbor.io", "k8s.gcr.io", "gcr.io", "quay.io"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl restart docker

# 此处应当修改为registry所在机器的IP

REGISTRY_HOST="192.168.3.111"

# 设置Hosts

yes | cp /etc/hosts /etc/hosts_bak
cat /etc/hosts_bak|grep -vE '(gcr.io|harbor.io|quay.io)' > /etc/hosts
echo """
$REGISTRY_HOST gcr.io harbor.io k8s.gcr.io quay.io """ >> /etc/hosts
