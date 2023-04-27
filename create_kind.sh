#!/bin/sh
set -o errexit

export $(cat .env)
cat <<EOF | kind create cluster --name ${MY_CLUSTER} --image kindest/node:${KUBE_VERSION} --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "127.0.0.1"
  apiServerPort: 6443
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker 
EOF

if [ ! -d ${MY_REPOSITORY} ]; then
    gh repo clone oliveirajoaop/flux
  else
    echo "the ${MY_REPOSITORY} was already cloned !"
fi
