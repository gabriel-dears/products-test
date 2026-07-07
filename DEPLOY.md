# CI/CD and GitOps Setup

This project is configured with GitHub Actions and Argo CD for a modern GitOps deployment pipeline.

## Architecture

```
GitHub Push → GitHub Actions → Build & Test → Docker Image → Update k8s/deployment.yaml → Argo CD Sync → Kubernetes
```

## Files

- [`.github/workflows/ci.yml`](./.github/workflows/ci.yml) - GitHub Actions CI/CD pipeline
- [`k8s/deployment.yaml`](./k8s/deployment.yaml) - Kubernetes Deployment, Service, and Ingress
- [`k8s/application.yaml`](./k8s/application.yaml) - Argo CD Application manifest
- [`k8s/kustomization.yaml`](./k8s/kustomization.yaml) - Kustomize configuration
- [`kind-config.yaml`](./kind-config.yaml) - Kind cluster configuration
- [`scripts/setup-kind.sh`](./scripts/setup-kind.sh) - Local cluster setup script

## Setup Instructions

### 1. GitHub Repository

1. Push this repository to GitHub
2. Enable GitHub Actions in your repository settings
3. The workflow will automatically build and push images to GitHub Container Registry (ghcr.io)

### 2. Local Kubernetes Cluster (kind)

```bash
# Make the script executable
chmod +x scripts/setup-kind.sh

# Run the setup script
./scripts/setup-kind.sh
```

This will:
- Create a kind cluster with 3 nodes
- Install Argo CD
- Install NGINX Ingress Controller

### 3. Deploy the Application

Update the `repoURL` in [`k8s/application.yaml`](./k8s/application.yaml) to your repository URL, then apply:

```bash
kubectl apply -f k8s/application.yaml
```

### 4. Access Argo CD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Get the admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Then open https://localhost:8080 in your browser.

## Pipeline Flow

1. **Push to main branch** triggers GitHub Actions
2. **Build stage**: Compiles Kotlin code and runs tests
3. **Docker build**: Creates and pushes image to ghcr.io
4. **Manifest update**: Updates image tag in `k8s/deployment.yaml`
5. **Argo CD sync**: Automatically syncs the new image to Kubernetes

## Customization

- Update `k8s/deployment.yaml` for resource limits, replicas, or environment variables
- Modify `.github/workflows/ci.yml` to add additional test stages or deployment targets
- Configure Argo CD sync policies in `k8s/application.yaml`