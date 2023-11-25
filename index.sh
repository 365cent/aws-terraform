#!/bin/bash

# Function to safely read sensitive input
safe_read() {
    read -r -p "$1: " -s input
    echo "$input"
}

# Ensure AWS CLI and Terraform are installed
install_aws_cli() {
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
}

# Creating AWS credentials file
create_aws_credentials() {
    echo "Setting up AWS credentials..."
    mkdir -p ~/.aws
    echo "[default]" > ~/.aws/credentials
    echo "aws_access_key_id = $1" >> ~/.aws/credentials
    echo "aws_secret_access_key = $2" >> ~/.aws/credentials
}

# Running AWS configure
configure_aws_cli() {
    echo "Configuring AWS CLI..."
    aws configure set default.region "$1"
}

# Initialize and Apply Terraform
initialize_and_apply_terraform() {
    echo "Initializing Terraform..."
    terraform init
    echo "Applying Terraform configuration..."
    terraform apply -var "name=$1" -var "blueprint_id=$2" -var "bundle_id=$3"
}

# Main script starts here
echo "Terraform and AWS Configuration Script"

# Read AWS credentials and region
read -r -p "Enter AWS Access Key ID: " aws_access_key_id
aws_secret_access_key=$(safe_read "Enter AWS Secret Access Key")
read -r -p "Enter AWS Region: " region

# Read Terraform variables
read -r -p "Enter Instance Name: " name
read -r -p "Enter Blueprint ID: " blueprint_id
read -r -p "Enter Bundle ID: " bundle_id

# Process
install_aws_cli
create_aws_credentials "$aws_access_key_id" "$aws_secret_access_key"
configure_aws_cli "$region"
initialize_and_apply_terraform "$name" "$blueprint_id" "$bundle_id"

echo "Script execution completed!"
