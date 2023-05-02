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

3) install flux v2 

```bash
./fluxv2.sh 
```

3) scale down the flux operator and flux to 0 replicas 

```bash
k scale deployment -n flux --replicas 0  --all 
```

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

    uninstall flux v1

```bash
helm uninstall helm-operator -n flux 
helm uninstall flux -n flux
kubectl delete crd helmreleases.helm.fluxcd.io
kubectl delete namespace flux  
```


7) scale up the flux deployment and sync 

```bash
 fluxctl sync --k8s-fwd-ns flux
```

8) check the test-configmap 

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
9) deploy a helm chart with extra parameters on flux v1 e fluxv2 

```bash
cat ./clusters/k8s/workflows/nginx2.yaml
```
10) notifications

```bash
kubectl -n flux-system create secret generic slack-url \
--from-literal=address=${SLACK}
```

11) tag system 

12) image automation 

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

https://fluxcd.io/flux/guides/image-update/

create demo:

```bash
git submodule update --recursive --remote
cp -R flux/v2-manifests/* flux/fluxv2/demo/.
cd flux 
git add . 
git commit -m "add demo"
git push -f origin HEAD:main
```


remove demo: 

```bash
cd flux 
rm -fr fluxv2
git add . 
git commit -m "remove demo"
git push -f origin HEAD:main
kind delete cluster --name demo
```


TODO proccess: 
1) deploy descale to 0 operator
2) deploy descale to 0 flux
3) helm install fluxv2
4) migrate the objects from v1 to v2 
5) helm uninstall helm-operator 
6) delete crd helmreleases.helm.fluxcd.io
7) helm uninstall fluxv1
8) delete namespace fluxv1 namespace


