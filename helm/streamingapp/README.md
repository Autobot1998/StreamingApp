# StreamingApp Helm Chart

This chart deploys four Node.js services, the React/Nginx frontend, and MongoDB.

## Validate

```bash
helm lint .
helm template streamingapp . > rendered.yaml
```

## Install

```bash
kubectl create namespace streamingapp
helm upgrade --install streamingapp . -n streamingapp
kubectl get pods,svc,pvc,ingress -n streamingapp
```

Do not commit real secret values. Supply them at install time or use workload identity.
