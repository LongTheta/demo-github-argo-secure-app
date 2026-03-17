#!/usr/bin/env bash
# Simple validation: YAML presence and file structure
# Run from repo root

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Validating demo-github-argo-secure-app structure"

REQUIRED_FILES=(
  ".github/workflows/ci.yml"
  "argo/application.yaml"
  "k8s/deployment.yaml"
  "k8s/service.yaml"
  "k8s/namespace.yaml"
  "Dockerfile"
  "app/app.py"
  "app/requirements.txt"
)

MISSING=0
for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$f" ]; then
    echo "  ✓ $f"
  else
    echo "  ✗ MISSING: $f"
    MISSING=1
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo ""
  echo "Validation FAILED: missing required files"
  exit 1
fi

echo ""
echo "Validation PASSED: all required files present"
