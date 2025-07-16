# ARM64 Linux Build Support

This document provides information about the ARM64 Linux build support added to the UUID CLI tool.

## Changes Made

1. Enabled ARM64 Linux (aarch64-unknown-linux-gnu) build target in the release workflow:
   - Uncommented the ARM64 Linux build configuration in `.github/workflows/release.yml`
   - Added configuration for ARM64 Linux in `Cross.toml`
   - ARM64 Linux was already included in the simulation matrix in `.github/workflows/release-local.yml`

## Testing Locally

Testing the ARM64 Linux build locally is feasible using the `act` tool, but with some limitations:

1. Docker images will run in emulation mode for ARM64 images on non-ARM64 hosts, which might cause performance degradation
2. The actual build process for ARM64 Linux targets won't work natively on non-ARM64 hosts, but the simulation job will work

### Steps to Test Locally

1. Make sure you have `act` installed:
   ```bash
   brew install act
   ```

2. Make sure Docker Desktop is running

3. Create or update the necessary configuration files as described in `act-setup.md`

4. To test the ARM64 Linux build simulation specifically:
   ```bash
   ./run-act-release.sh --local -j simulate-platforms --matrix target:aarch64-unknown-linux-gnu
   ```

5. To test the entire release workflow with all platforms:
   ```bash
   ./run-act-release.sh --local
   ```

## Notes and Recommendations

1. **Cross-Compilation**: The actual building of ARM64 Linux binaries happens on GitHub's Ubuntu runners using the `cross` tool, not locally.

2. **Testing Strategy**: 
   - Use `act` for workflow validation and simulation
   - For actual binary testing, rely on GitHub Actions or an ARM64 Linux environment

3. **Compatibility**: 
   - ARM64 Linux support is important for modern ARM-based servers and devices
   - Consider testing the ARM64 Linux build on actual ARM64 Linux systems if possible

4. **Maintenance**: 
   - Keep the ARM64 Linux build enabled in future releases
   - Monitor for any issues specific to the ARM64 build