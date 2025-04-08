#!/bin/bash

# ============================================================
# Script Name: zfs.sh
# Description: Loads the ZFS encryption keys for specified
#              datasets using a single passphrase and mounts
#              the datasets if the key is successfully loaded.
# Usage:       sudo ./zfs.sh [dataset1 dataset2 ...]
# ============================================================

# ----------------------------
# Configuration Variables
# ----------------------------

# Replace with your actual ZFS datasets, separated by spaces
# Example: "pool1/dataset1 pool1/dataset2"
ZFS_DATASETS="zfs_hdd_pool_01"

# ----------------------------
# Function Definitions
# ----------------------------

# Function to display usage information
usage() {
    echo "Usage: sudo $0 [dataset1 dataset2 ...]"
    echo
    echo "If no datasets are provided as arguments, the script uses the datasets defined in the configuration."
    exit 1
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to prompt for the passphrase
prompt_passphrase() {
    local pass
    echo "🔒 Enter passphrase for ZFS encryption keys:"
    # Prompt for passphrase without echoing
    read -s pass
    echo
    PASSPHRASE="$pass"
    unset pass
}

# Function to load ZFS encryption key for a single dataset
load_zfs_key() {
    local dataset="$1"
    echo "🔑 Loading ZFS encryption key for dataset: $dataset"

    # Attempt to load the key using the provided passphrase
    if ! printf '%s' "$PASSPHRASE" | zfs load-key "$dataset"; then
        echo "❌ Error: Failed to load ZFS key for $dataset."
        exit 1
    fi

    echo "✅ ZFS key for $dataset loaded successfully."
}

# Function to mount a ZFS dataset
mount_zfs_dataset() {
    local dataset="$1"
    echo "🌐 Mounting ZFS dataset: $dataset"

    if ! zfs mount "$dataset"; then
        echo "❌ Error: Failed to mount dataset $dataset."
        exit 1
    fi

    echo "✅ Dataset $dataset mounted successfully."
}

# Function to check prerequisites
check_prerequisites() {
    # Check if ZFS is installed
    if ! command_exists zfs; then
        echo "❌ Error: ZFS is not installed or not in the PATH."
        exit 1
    fi
}

# ----------------------------
# Main Script Execution
# ----------------------------

# Ensure the script is run with sufficient privileges
if [ "$EUID" -ne 0 ]; then
    echo "⚠️ Please run this script with sudo or as the root user."
    exit 1
fi

# Handle command-line arguments
if [ "$#" -gt 0 ]; then
    ZFS_DATASETS="$*"
fi

# Validate that at least one dataset is specified
if [ -z "$ZFS_DATASETS" ]; then
    echo "❌ Error: No ZFS datasets specified."
    usage
fi

# Check for prerequisites
check_prerequisites

# Prompt for the passphrase once
prompt_passphrase

# Iterate over each dataset and load the encryption key, then mount the dataset
for dataset in $ZFS_DATASETS; do
    load_zfs_key "$dataset"
    mount_zfs_dataset "$dataset"
done

# Clear the passphrase from memory
unset PASSPHRASE

echo "🎉 Script completed successfully."
exit 0
