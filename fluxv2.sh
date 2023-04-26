#!/bin/sh
set -o errexit

export $(cat .env)

flux bootstrap github --owner=${GITHUB_REPOSITORY_OWNER} \
  --repository=${MY_REPOSITORY} \
  --secret-name=${SECRET} \
  --path=./clusters/${MY_CLUSTER}/ \
  --branch=${BRANCH} \
  --personal \
  --private=true

echo "flux booted"
