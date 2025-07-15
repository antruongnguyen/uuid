# Testing GitHub Actions Locally with `act`

This repository is configured to work with [`act`](https://github.com/nektos/act), a tool that allows you to run GitHub Actions workflows locally.

## Quick Start

1. Install prerequisites:
   ```bash
   # Install act
   brew install act
   
   # Make sure Docker Desktop is installed and running
   ```

2. Set up your GitHub token:
   ```bash
   # Copy the template and add your token
   cp .secrets.template .secrets
   # Edit .secrets with your GitHub token
   ```

3. Run the release workflow:
   ```bash
   # Run the simplified local workflow (recommended for M3 Macs)
   ./run-act-release.sh --local
   
   # Or run the full workflow (may have compatibility issues)
   ./run-act-release.sh
   ```

## What's Included

- `.actrc`: Configuration for Docker images
- `release-event.json`: Simulated tag push event
- `.secrets.template`: Template for GitHub token
- `run-act-release.sh`: Script to run the workflow
- `.github/workflows/release-local.yml`: Simplified workflow for local testing

## Detailed Documentation

For more detailed information, see [act-setup.md](act-setup.md).

## Notes for Apple Silicon (M3)

When running on Apple Silicon (M3):
- Use the `--local` flag with the run script for better compatibility
- Docker will run x86_64 images in emulation mode, which may be slower
- The simplified workflow avoids cross-compilation issues

## Troubleshooting

If you encounter issues:
1. Make sure Docker is running
2. Check that your GitHub token is correctly set in `.secrets`
3. Try running with the `--local` flag for the simplified workflow
4. For specific job testing, use: `./run-act-release.sh --local -j create-release`