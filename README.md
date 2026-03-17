# demo-github-argo-secure-app

**Secure-by-default GitHub Actions + Argo CD demo application** — the golden path example that passes DevSecOps policy enforcement and can safely be promoted through a GitOps platform into production.

---

## Example Policy Outcome

```text
✅ Policy Verdict: PASS
Risk Score: Low
Promotion Eligible: Yes

Artifacts Generated:
- report.md
- review-result.json
- policy-summary.json
```

Run the policy agent (see [How to Test](#how-to-test)) to reproduce this result. Contrast with [demo-github-argo-insecure-app](https://github.com/LongTheta/demo-github-argo-insecure-app), which fails policy checks and is blocked from promotion.

---

## What This Repo Is

A clean, realistic demo application that:

- Uses **GitHub Actions** for CI/CD with pinned dependencies
- Deploys via **Argo CD** to Kubernetes with safe GitOps patterns
- Is **intentionally configured** to pass policy enforcement
- Serves as the **golden path** contrast to [demo-github-argo-insecure-app](https://github.com/LongTheta/demo-github-argo-insecure-app)

---

## What It Demonstrates

| Practice | Implementation |
|----------|----------------|
| **Compliant CI/CD** | Pinned actions (SHA), least privilege permissions |
| **Pinned dependencies** | No `latest` tags; images and actions pinned |
| **SBOM readiness** | SBOM generation step (placeholder for syft) |
| **Provenance readiness** | Placeholder for cosign/signing |
| **Secure Kubernetes** | `securityContext`, resource limits, non-root |
| **Safe GitOps** | Pinned `targetRevision`, no risky auto-prune/selfHeal |

---

## Key Differences from Insecure Repo

| Feature | Insecure Repo | Secure Repo |
|---------|---------------|-------------|
| Image Tag | `latest` | Pinned (`1.0.0`, digest in prod) |
| GitHub Actions | Floating (`@v4`) | Pinned to commit SHA |
| SBOM | None | Present (placeholder/real) |
| Security Context | Missing | Defined (runAsNonRoot, readOnlyRootFilesystem) |
| Resource Limits | Missing | requests + limits |
| Argo targetRevision | `HEAD` | Pinned (`main` or tag) |
| Argo prune/selfHeal | `true` | `false` (intentional) |
| Promotion | Blocked | Allowed |

---

## How to Test

### Prerequisites

- Clone [ai-devsecops-policy-enforcement-agent](https://github.com/LongTheta/ai-devsecops-policy-enforcement-agent) as a sibling
- Install: `cd ai-devsecops-policy-enforcement-agent && pip install -e .`

### Run policy review

From this repo root:

```bash
python -m ai_devsecops_agent.cli review-all \
  --platform github \
  --pipeline .github/workflows/ci.yml \
  --gitops argo/application.yaml \
  --manifests k8s/deployment.yaml \
  --include-comments \
  --include-remediations \
  --include-risk-score \
  --artifact-dir artifacts/
```

### Expected result

- **Policy Verdict:** PASS (or PASS_WITH_WARNINGS)
- **Risk Score:** Low
- **Promotion Eligible:** Yes
- Artifacts in `artifacts/`: `report.md`, `review-result.json`, `policy-summary.json`

---

## Repository Structure

```
demo-github-argo-secure-app/
├── README.md
├── Dockerfile              # Pinned python:3.11.9-slim
├── app/
│   ├── app.py
│   └── requirements.txt    # Pinned versions
├── .github/workflows/
│   └── ci.yml              # Secure CI: pinned actions, SBOM, provenance
├── k8s/
│   ├── deployment.yaml     # securityContext, resources, pinned image
│   ├── service.yaml
│   └── namespace.yaml
├── argo/
│   └── application.yaml    # Pinned revision, safe sync policy
├── scripts/
│   └── validate.sh         # Structure validation
└── artifacts/
    └── .gitkeep
```

---

## Comparison

| Feature | Insecure Repo | Secure Repo |
|--------|---------------|-------------|
| Image Tag | latest | pinned |
| GitHub Actions | floating | pinned |
| SBOM | none | present |
| Security Context | missing | defined |
| Resource Limits | missing | defined |
| Argo prune/selfHeal | true | false |
| Promotion | blocked | allowed |

---

## How This Fits into GitOps Platform

- **Golden path application** — reference implementation for teams
- **Policy-compliant** — passes enforcement before promotion
- **Promotion flow** — dev → stage → prod with version pinning
- **Contrast demo** — run policy agent on both repos to show PASS vs FAIL

---

## Run Locally

```bash
cd app
pip install -r requirements.txt
python app.py
```

Visit http://localhost:8080/ or http://localhost:8080/health

---

## License

MIT (demo only)
