#/bin/bash

NS="hknflow-flux-system"

NS_ON_KUBERNETES=$(kubectl get ns $NS)

if [[ "${NS}" == "$NS_ON_KUBERNETES" ]]; then
  echo "$NS exists already!"
 else 
  kubectl create ns $NS
 fi

 kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml -n $NS
