# ⚠️ GitHub Actions Currently Disabled

## Project Overview

This project demonstrates deploying a containerised Flask application to AWS EKS using Docker, Helm, Terraform, and GitHub Actions.

### What This Project Does

* Builds a **Flask application** written in Python
* Uses **Docker** to package the Flask app into a container image
* Deploys the application via a **custom Helm chart**
* Provisions an **AWS EKS cluster** using Terraform
* Deploys the Flask application to EKS using Terraform + Helm
* Installs **NGINX Ingress Controller** via Helm for external access
* Uses an **S3-backed Terraform state** for infrastructure management

All infrastructure and application components are designed to be deployed end-to-end by manually triggering the GitHub Actions pipeline.

---

## Deployment Flow

1. GitHub Actions pipeline is triggered manually
2. Terraform provisions the EKS cluster
3. Helm charts are applied via Terraform:

   * Flask application
   * NGINX Ingress Controller
4. Application is exposed externally through an Ingress resource

---

## Verifying the Deployment

Once the pipeline has completed successfully, you can verify the deployment locally.

### Update kubeconfig

```bash
aws eks --region eu-west-2 update-kubeconfig --name flask-eks-cluster
```

### Check Ingress resources

```bash
kubectl get ingresses -A
```

### Test application health endpoint

```bash
curl <INGRESS_ADDRESS>/health
```

A successful response should return **HTTP 200**, indicating the application is healthy.
