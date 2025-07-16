# Testing the Release Workflow with `act`

This document explains how to test the GitHub Actions release workflow locally using `act`.

## Prerequisites

- Install `act` using Homebrew: `brew install act`
- Make sure Docker Desktop is installed and running
- Set up your GitHub token in `.secrets` file (copy from `.secrets.template`)

## Testing the Release Workflow

The repository includes a simplified workflow for local testing that builds the package for the current platform and simulates builds for other platforms.

### Running the Test

```bash
# Run the simplified local workflow (recommended)
./run-act-release.sh --local

# Or run a specific job
./run-act-release.sh --local -j build-native
```

## What's Being Tested

The simplified workflow (`release-local.yml`) includes:

1. A `build-native` job that:
   - Sets up Rust
   - Installs required dependencies (X11/XCB libraries)
   - Builds the package for the current platform
   - Tests the built binary
   - Creates a release artifact
   - Validates the built packages are ready for upload

2. A `simulate-platforms` job that simulates builds for:
   - Linux (x86_64 and ARM64)
   - macOS (x86_64 and ARM64)
   - Windows (x86_64 and i686/32-bit)

### Testing Specific Platforms

To test a specific platform, use the `-j simulate-platforms` option with the `--matrix target:<platform>` parameter:

```bash
# Test Windows 32-bit (i686) build
./run-act-release.sh --local -j simulate-platforms --matrix target:i686-pc-windows-msvc

# Test macOS x86_64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:x86_64-apple-darwin

# Test macOS ARM64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:aarch64-apple-darwin

# Test Linux x86_64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:x86_64-unknown-linux-gnu
```

## Notes for Apple Silicon (M3)

When running on Apple Silicon (M3):
- Docker will run x86_64 images in emulation mode, which may be slower
- You might see a warning about container architecture
- If you encounter issues, try running with `--container-architecture linux/amd64`:
  ```bash
  ./run-act-release.sh --local --container-architecture linux/amd64
  ```

## Package Validation

The simplified workflow includes a validation step that replaces the "Upload Release Assets" step from the full workflow. This is because GitHub release uploads cannot be performed in a local environment.

The validation step:
1. Checks if the tarball exists and reports its size
2. Verifies that the tarball contains the binary
3. Checks if the checksum file exists and reports its size
4. Verifies that the checksum in the file matches the actual checksum of the tarball

This validation ensures that the packages are correctly built and ready for upload, without actually attempting to upload them to GitHub.

## Troubleshooting

If you encounter build failures:
1. Check the error message for missing dependencies
2. Make sure the required dependencies are installed in the workflow
3. For cross-compilation issues, check the Cross.toml file

## Full vs. Simplified Workflow

The repository includes two workflows:
- `release.yml`: The full workflow that runs on GitHub Actions
- `release-local.yml`: A simplified workflow for local testing

The simplified workflow avoids cross-compilation issues by:
1. Building only for the current platform
2. Simulating builds for other platforms
