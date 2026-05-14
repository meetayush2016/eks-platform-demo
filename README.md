# eks-platform-demo

Production-grade Kubernetes platform on AWS — built with Terraform, Helm, GitHub Actions, Prometheus, and Grafana.

---

## Architecture

```
Internet → GitHub Actions (CI/CD)
                  ↓
            ECR (Docker Image)
                  ↓
         EKS Cluster (Kubernetes)
          ↙              ↘
   Node.js App        Prometheus
   (Helm Chart)       + Grafana
          ↑
   Terraform (Infrastructure)
   VPC + Subnets + IAM + EKS
```

---

## Stack

| Layer | Technology |
|---|---|
| Infrastructure | Terraform (modular) |
| Container Orchestration | AWS EKS + Helm |
| CI/CD | GitHub Actions → ECR → Rolling Deploy |
| Application | Node.js REST API |
| Observability | Prometheus + Grafana |
| Cloud | AWS (VPC, EKS, ECR, ALB, Route53) |

---

## Repo Structure

```
eks-platform-demo/
├── terraform/          # Infrastructure as Code — VPC, EKS, IAM
│   └── modules/
│       ├── vpc/        # Network layer
│       └── eks/        # Cluster layer
├── helm/               # Kubernetes deployment config
│   └── app/            # Helm chart for Node.js app
├── app/                # Application source code
│   ├── Dockerfile
│   └── src/index.js
├── .github/workflows/  # CI/CD pipeline definitions
└── monitoring/         # Prometheus + Grafana dashboards
```

---

## Phases

| Phase | Description | Status |
|---|---|---|
| 0 | Repo setup, folder structure, architecture decisions | Done |
| 1 | Terraform — VPC and EKS cluster provisioning | In Progress |
| 2 | Node.js app + Dockerization | Pending |
| 3 | Helm chart + Kubernetes deployment | Pending |
| 4 | GitHub Actions CI/CD pipeline | Pending |
| 5 | Prometheus + Grafana observability | Pending |

---

## Interview Design Decisions

**Why modular Terraform?**
Each module (vpc, eks) is independently deployable and reusable across environments. Changing EKS config never touches VPC code.

**Why Helm for deployments?**
Helm separates Kubernetes config (templates) from environment values (values.yaml). Promotes to production by changing one file, not rewriting manifests.

**Why GitHub Actions over Jenkins?**
Native GitHub integration, no server to maintain, free for public repos. Pipeline lives in the same repo as the code it deploys.

---

*Built by Ayush Sharma — [LinkedIn](https://linkedin.com/in/itsayush2252)*