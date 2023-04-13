#!/bin/sh
set -e
echo lets hope you did update the domain names, after set up dont forget to configure the correct dns name for ingress
if [ -n "${KUBECONFIG+x}" ]; then
  echo "the kubeconfig is $KUBECONFIG"
else
  echo "please set KUBECONFIG"
fi
echo proceeding...
helm repo add jetstack https://charts.jetstack.io
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
echo helm repo update success
kubectl create configmap lighttpd-config --from-file=lighttpd-config/ -n werc-host
kubectl apply -f werc-host-ns.yaml
kubectl apply -f werc-pvc.yaml
kubectl apply -f nfs-deployment.yaml
kubectl apply -f werc-host-werc-deployment.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.7.1 --create-namespace --set installCRDs=true
helm upgrade --install nginx-ingress nginx-stable/nginx-ingress
kubectl apply -f service-ingress.yaml
