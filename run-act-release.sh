#!/bin/bash

# Script to run the release workflow with act

# Check if act is installed
if ! command -v act &> /dev/null; then
    echo "Error: 'act' is not installed. Please install it with 'brew install act'"
    exit 1
fi

# Check if Docker is running
#if ! docker info &> /dev/null; then
#    echo "Error: Docker is not running. Please start Docker Desktop"
#    exit 1
#fi

# Check if .secrets file exists
if [ ! -f .secrets ]; then
    echo "Warning: .secrets file not found. Creating from template..."
    cp .secrets.template .secrets
    echo "Please edit .secrets and add your GitHub token before continuing."
    exit 1
fi

# Run the workflow
echo "Running release workflow with act..."
echo "This will simulate a tag push event with tag v0.0.0-test"

# Parse arguments
USE_LOCAL=false
JOB_PARAM=""
EXTRA_PARAMS=""

for arg in "$@"; do
    if [ "$arg" == "--local" ]; then
        USE_LOCAL=true
    elif [[ "$arg" == -j* ]]; then
        JOB_PARAM="$arg"
    else
        EXTRA_PARAMS="$EXTRA_PARAMS $arg"
    fi
done

# Check if we should use the simplified local workflow
if [ "$USE_LOCAL" = true ]; then
    echo "Using simplified local workflow (release-local.yml)..."
    act push --eventpath release-event.json --secret-file .secrets -W .github/workflows/release-local.yml $JOB_PARAM $EXTRA_PARAMS
else
    echo "Using full release workflow (release.yml)..."
    act push --eventpath release-event.json --secret-file .secrets $JOB_PARAM $EXTRA_PARAMS
fi

# Examples of running only specific jobs:
# act push -j create-release --eventpath release-event.json --secret-file .secrets
# act push -j build-release --eventpath release-event.json --secret-file .secrets
# act push -j package-assets --eventpath release-event.json --secret-file .secrets

echo "Done!"
