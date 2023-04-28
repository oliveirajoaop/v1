#!/bin/sh
set -o errexit

export $(cat .env)

kubectl create namespace flux

kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

helm repo add fluxcd https://charts.fluxcd.io
helm repo update


ssh-keygen -q -N "" -f ./identity

kubectl -n flux create secret generic flux-ssh --from-file=./identity


cd ${MY_REPOSITORY}

for i in $(gh repo deploy-key list | awk '{print $1}'); do gh repo deploy-key delete $i; done

gh repo deploy-key add ../identity.pub -w -t fluxv1


helm upgrade -i flux fluxcd/flux \
--set git.url=git@github.com:oliveirajoaop/${MY_REPOSITORY} \
--set git.secretName=${SECRET} \
--set git.secretDataKey=identity \
--set git.path=kubernetes \
--set git.branch=main \
--set createCRD=true \
--set memcached.enabled=false \
--namespace flux

helm upgrade -i helm-operator fluxcd/helm-operator \
--set git.ssh.secretName=${SECRET} \
--set helm.versions=v3 \
--namespace flux

fluxctl sync --k8s-fwd-ns flux
