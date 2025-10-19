#!/bin/bash

# Set variables
TERRAFORM_URL="https://releases.hashicorp.com/terraform"
INSTALL_DIR="/usr/local/bin"

# Get the latest Terraform version
LATEST_VERSION=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | sed 's/^v//')

if [ -z "$LATEST_VERSION" ]; then
    echo "❌ Failed to fetch the latest Terraform version."
    exit 1
fi

echo "📌 Latest Terraform version: $LATEST_VERSION"

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) ARCH="amd64" ;;
    arm64)  ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "🔍 Detected OS: $OS, Architecture: $ARCH"

# Define download URL
TERRAFORM_DOWNLOAD_URL="$TERRAFORM_URL/${LATEST_VERSION}/terraform_${LATEST_VERSION}_${OS}_${ARCH}.zip"

echo "📥 Downloading Terraform from: $TERRAFORM_DOWNLOAD_URL"

# Download and extract Terraform
curl -LO "$TERRAFORM_DOWNLOAD_URL"
unzip "terraform_${LATEST_VERSION}_${OS}_${ARCH}.zip"
rm "terraform_${LATEST_VERSION}_${OS}_${ARCH}.zip"

# Move to installation directory
sudo mv terraform "$INSTALL_DIR/terraform"
sudo chmod +x "$INSTALL_DIR/terraform"

echo "✅ Terraform $LATEST_VERSION installed successfully!"
terraform version
