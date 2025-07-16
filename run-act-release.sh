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
MATRIX_PARAM=""
EXTRA_PARAMS=""

# Process arguments
i=1
while [ $i -le $# ]; do
    arg="${!i}"

    if [ "$arg" == "--local" ]; then
        USE_LOCAL=true
    elif [[ "$arg" == -j* ]]; then
        # Check if the parameter is in the format -j=value or -j value
        if [[ "$arg" == *"="* ]]; then
            # Format is -j=value
            JOB_PARAM="$arg"
        elif [ $i -lt $# ]; then
            # Get the next argument
            next_i=$((i+1))
            next_arg="${!next_i}"
            # Check if the next argument starts with a dash (indicating it's another option)
            if [[ "$next_arg" == -* ]]; then
                # -j is followed by another option
                JOB_PARAM="$arg"
            else
                # Format is -j value, get the next argument as the value
                # Use -j=value format to ensure it's passed as a single argument
                JOB_PARAM="-j=$next_arg"
                i=$((i+1))  # Skip the next argument since we've used it
            fi
        else
            # -j is the last argument
            JOB_PARAM="$arg"
        fi
    elif [[ "$arg" == -m* ]]; then
        # -m is not a valid flag for act, convert to --matrix
        if [[ "$arg" == *"="* ]]; then
            # Format is -m=value or -m=key=value
            # Convert to --matrix value
            MATRIX_PARAM="--matrix ${arg#-m=}"
        elif [ $i -lt $# ]; then
            # Get the next argument
            next_i=$((i+1))
            next_arg="${!next_i}"
            # Check if the next argument starts with a dash (indicating it's another option)
            if [[ "$next_arg" == -* ]]; then
                # -m is followed by another option
                echo "Warning: -m parameter requires a value"
                # Don't add the parameter since it's invalid
                MATRIX_PARAM=""
            else
                # Format is -m value, get the next argument as the value
                MATRIX_PARAM="--matrix $next_arg"
                i=$((i+1))  # Skip the next argument since we've used it
            fi
        else
            # -m is the last argument with no value
            echo "Warning: -m parameter requires a value"
            # Don't add the parameter since it's invalid
            MATRIX_PARAM=""
        fi
    else
        EXTRA_PARAMS="$EXTRA_PARAMS $arg"
    fi

    i=$((i+1))
done

# Check if we should use the simplified local workflow
if [ "$USE_LOCAL" = true ]; then
    echo "Using simplified local workflow (release-local.yml)..."
    # Print the command for debugging
    echo "Command: act push --eventpath release-event.json --secret-file .secrets -W .github/workflows/release-local.yml $JOB_PARAM $MATRIX_PARAM $EXTRA_PARAMS"
    # Execute the command
    act push --eventpath release-event.json --secret-file .secrets -W .github/workflows/release-local.yml $JOB_PARAM $MATRIX_PARAM $EXTRA_PARAMS
else
    echo "Using full release workflow (release.yml)..."
    # Print the command for debugging
    echo "Command: act push --eventpath release-event.json --secret-file .secrets $JOB_PARAM $MATRIX_PARAM $EXTRA_PARAMS"
    # Execute the command
    act push --eventpath release-event.json --secret-file .secrets $JOB_PARAM $MATRIX_PARAM $EXTRA_PARAMS
fi

# Examples of running only specific jobs:
# ./run-act-release.sh --local -j create-release
# ./run-act-release.sh --local -j build-release
# ./run-act-release.sh --local -j package-assets
# 
# Examples of testing specific platforms:
# ./run-act-release.sh --local -j simulate-platforms --matrix target:x86_64-apple-darwin
# ./run-act-release.sh --local -j simulate-platforms --matrix target:i686-pc-windows-msvc

echo "Done!"
