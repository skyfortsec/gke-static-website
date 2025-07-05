# GKE Static Website Deployment with Terraform and GitHub Actions

This repository provides a complete example of deploying a static website on Google Kubernetes Engine (GKE) using:

- Terraform for infrastructure provisioning
- GitHub Actions for CI/CD
- NGINX to serve static files (HTML, CSS, JS)
- Optional HTTPS with a custom domain via Cloud Load Balancer + Cert Manager

---

## 🧱 Project Structure

```
.
├── terraform/              # Terraform files for GKE, K8s, and networking
├── website/                # Static website files
└── .github/workflows/      # GitHub Actions CI/CD workflows
```

---

## 🚀 Deployment

### 1. Setup Secrets in GitHub
In your GitHub repository, add the following secrets:
- `GCP_PROJECT_ID`
- `GCP_SA_KEY` (Service Account JSON key)
- `GCP_ZONE`

### 2. Trigger CI/CD

- Any `push` to `main` branch → triggers `deploy.yml`
- Manual teardown via Actions tab → run `destroy.yml`

---

## ✅ CI/CD Badges

Add this to your README:

![Deploy](https://github.com/<your-org-or-username>/<your-repo>/actions/workflows/deploy.yml/badge.svg)
![Destroy](https://github.com/<your-org-or-username>/<your-repo>/actions/workflows/destroy.yml/badge.svg)

Replace `<your-org-or-username>` and `<your-repo>` with your GitHub info.

---

## 🌐 Custom Domain + HTTPS

To use your domain with HTTPS:

1. Reserve a static IP address:

```bash
gcloud compute addresses create gke-static-ip --region=us-central1
```

2. Add a `dns_record` in your registrar with the reserved IP.

3. Deploy **Cert Manager** and **Ingress** using Kubernetes manifests or Helm:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
```

4. Create a `ClusterIssuer` for Let’s Encrypt and an `Ingress` with TLS enabled.

---

## 🔚 Cleanup

To destroy everything:

```bash
terraform destroy -var="project_id=your-project-id" -var="zone=your-zone"
```
Or trigger the `Destroy GKE Infrastructure` workflow from GitHub Actions tab.

---

## 📄 License

MIT License
