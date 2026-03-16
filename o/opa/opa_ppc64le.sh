#!/bin/bash
# -----------------------------------------------------------------------------
#
# Package          : opa
# Version          : 1.13.1
# Source repo      : https://github.com/open-policy-agent/opa
# Tested on        : IBM Power arch (ppc64le)
# Script License   : Apache License, Version 2 or later
# Maintainer       : Megha .<Megha.Megha6@ibm.com>
#
# Disclaimer       : This script has been tested in root mode on given
# ==========         platform using the mentioned version of the package.
#                    It may not work as expected with newer versions of the
#                    package and/or distribution. In such case, please
#                    contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------

OPA_REPO="https://github.com/open-policy-agent/opa.git"
OPA_DIR="opa"
OPA_VERSION=${1:-1.13.1}
NODE_VERSION_REQUIRED=20

echo "===== STEP 1: Clone OPA repository ====="
if [ ! -d "$OPA_DIR" ]; then
    git clone "$OPA_REPO" "$OPA_DIR"
fi

cd "$OPA_DIR"

echo "===== STEP 2: Verify Node.js ====="
if ! command -v node >/dev/null; then
    echo "Node.js not installed. Install Node.js >= $NODE_VERSION_REQUIRED"
    exit 1
fi

NODE_MAJOR=$(node -v | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_MAJOR" -lt "$NODE_VERSION_REQUIRED" ]; then
    echo "Node.js version too old. Required >= $NODE_VERSION_REQUIRED"
    exit 1
fi

echo "Node: $(node -v)"
echo "npm: $(npm -c)"

echo "===== STEP 3: Build OPA ======"

cd docs

echo "Installing Node dependencies..."
make install

echo "Starting development preview (CTRL+C to stop)..."
export PORT=3001
make dev || true

echo "Building production site..."
make build

echo "===== Build complete ====="
