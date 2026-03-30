#!/bin/bash
set -e

echo "=== Destroying all Terraform environments ==="
echo ""

BASE_DIR="$(dirname "$0")/../environments"
SUB_ID="${1:?Usage: ./scripts/destroy-all.sh <subscription_id>}"

for dir in "$BASE_DIR"/*/; do
  if [ -f "$dir/main.tf" ]; then
    ENV=$(basename "$dir")
    echo "--- Destroying: $ENV ---"
    cd "$dir"
    terraform init -input=false > /dev/null 2>&1
    terraform destroy -auto-approve -var="subscription_id=$SUB_ID"
    cd - > /dev/null
    echo ""
  fi
done

echo "=== All environments destroyed ==="
echo ""
echo "Remaining Terraform-managed resource groups:"
az group list --query "[?tags.managed_by=='terraform']" --output table
