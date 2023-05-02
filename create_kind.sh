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

# if [ ! -d ${MY_REPOSITORY} ]; then
#     gh repo clone ${GITHUB_USER}/flux
#   else
#     echo "the ${MY_REPOSITORY} was already cloned !"
# fi

rm -f identity*

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
sleep 90 

kubectl apply -f - <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - 172.20.25.200-172.20.25.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF