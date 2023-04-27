# fluxv1 to fluxv2

manifests: https://github.com/Orpere/flux

## prepare your .env 

```bash 
vim .env 
...
GITHUB_TOKEN=
GITHUB_REPOSITORY_OWNER=
GITHUB_USER=
MY_CLUSTER=
MY_REPOSITORY=
BRANCH=
KUBE_VERSION=v1.25.3
PASSWORD=
SECRET=flux-ssh
SLACK=
...
```



1) create a cluster 

```bash
./create_kind.sh
```

2) install flux v1 

```bash
./fluxv1.sh
```

3) install flu v2 

```bash
./fluxv2.sh 
```

3) scale down the flux operator and flux to 0 replicas 

4) reconcilie 

```bash
flux reconcile hr nginx -n default
flux reconcile kustomization flux-system --with-source
``` 

5) check if the config map was changed for 

```
 Name:         test-configmap                                                                                                                                                                     │
│ Namespace:    default                                                                                                                                                                            │
│ Labels:       kustomize.toolkit.fluxcd.io/name=flux-system                                                                                                                                       │
│               kustomize.toolkit.fluxcd.io/namespace=flux-system                                                                                                                                  │
│ Annotations:  <none>                                                                                                                                                                             │
│                                                                                                                                                                                                  │
│ Data                                                                                                                                                                                             │
│ ====                                                                                                                                                                                             │
│ test:                                                                                                                                                                                            │
│ ----                                                                                                                                                                                             │
│ test configmap flux v2                                                                                                                                                                           │
│                                                                                                                                                                                                  │
│ BinaryData                                                                                                                                                                                       │
│ ====                                                                                                                                                                                             │
│                                                                                                                                                                                                  │
│ Events:  <none>
```


6) delete flux v2 namespace 

```bash
  # Uninstall Flux but keep the namespace
  flux uninstall --namespace=flux-system --keep-namespace=true

```

7) scale up the flux deployment and sinc 

```bash
 fluxctl sync --k8s-fwd-ns flux
```

8) ccheck the test-configmap 

```
│ Name:         test-configmap                                                                                                                                                                     │
│ Namespace:    default                                                                                                                                                                            │
│ Labels:       fluxcd.io/sync-gc-mark=sha256.WaB78dgFgRgoZ_BK5dtC3QHHR7rW6F1tzlD6fB44NQU                                                                                                          │
│               kustomize.toolkit.fluxcd.io/name=flux-system                                                                                                                                       │
│               kustomize.toolkit.fluxcd.io/namespace=flux-system                                                                                                                                  │
│ Annotations:  fluxcd.io/sync-checksum: a8de40f3a5d79e8a083fb5a39f35ea3e393f1193                                                                                                                  │
│                                                                                                                                                                                                  │
│ Data                                                                                                                                                                                             │
│ ====                                                                                                                                                                                             │
│ test:                                                                                                                                                                                            │
│ ----                                                                                                                                                                                             │
│ test configmap flux v1                                                                                                                                                                           │
│                                                                                                                                                                                                  │
│ BinaryData                                                                                                                                                                                       │
│ ====                                                                                                                                                                                             │
│                                                                                                                                                                                                  │
│ Events:  <none>
```
9) deploy a helm chart with extra paramters on flux v1 e fluxv2 

```bash
cat ./clusters/k8s/workflows/nginx2.yaml
```
10) notifications

```bash
kubectl -n flux-system create secret generic slack-url \
--from-literal=address=${SLACK}
```

11) tag system 

12) image management

13) disaster recovery 

run the bootstrap again and it shoud install all manifests 

14) create manifests using cli 

example:

```bash
flux create hr myrelease \
    --source=HelmRepository/mychart \
    --chart=mychart \
    --export > mychart-release.yaml

flux create source helm mychart  \
  --url https://my-registry/dir \
  --export > repository.yaml
```

15) multitenancy 


notes: 
helm sources can be git, helmrepo, s3 

ref: 

https://www.youtube.com/watch?v=r_vKf5l1D1M&t=2560s

https://devopscube.com/build-docker-image/

https://helm.sh/docs/chart_template_guide/accessing_files/

https://fluxcd.io/flux/

https://github.com/weaveworks/weave-gitops

https://fluxcd.io/flux/guides/notifications/


