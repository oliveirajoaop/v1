#!/bin/sh
set -o errexit

export $(cat .env)


if [ ! -f /usr/local/bin/gitops ]; then
    curl --silent --location "https://github.com/weaveworks/weave-gitops/releases/download/v0.21.2/gitops-$(uname)-$(uname -m).tar.gz" | tar xz -C /tmp
    sudo mv /tmp/gitops /usr/local/bin
    gitops version
fi

cd ${MY_REPOSITORY}
gitops create dashboard ww-gitops \
  --password=${PASSWORD} \
  --export > ./clusters/${MY_CLUSTER}/workflows/weave-gitops-dashboard.yaml

git add -A && git commit -m "Add Weave GitOps Dashboard"
git push

# kubectl port-forward svc/ww-gitops-weave-gitops -n flux-system 9001:9001