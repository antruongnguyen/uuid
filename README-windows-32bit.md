# Windows 32bit Build Support

This document provides information about the Windows 32bit build support added to the UUID CLI tool.

## Changes Made

1. Enabled Windows 32bit (i686-pc-windows-msvc) build target in the release workflow:
   - Uncommented the Windows 32bit build configuration in `.github/workflows/release.yml`
   - Added Windows 32bit to the simulation matrix in `.github/workflows/release-local.yml`
   - Updated `run-act-release.sh` with examples of how to test the Windows 32bit build

## Testing Locally on macOS M3 Chip

Testing the Windows 32bit build locally on macOS with an M3 chip is feasible using the `act` tool, but with some limitations:

1. Docker images will run in emulation mode for x86_64 images, which might cause performance degradation
2. The actual build process for Windows targets won't work natively on macOS, but the simulation job will work

### Steps to Test Locally

1. Make sure you have `act` installed:
   ```bash
   brew install act
   ```

2. Make sure Docker Desktop is running

3. Create or update the necessary configuration files as described in `act-setup.md`

4. To test the Windows 32bit build simulation specifically:
   ```bash
   ./run-act-release.sh --local -j simulate-platforms --matrix target:i686-pc-windows-msvc
   ```

5. To test the entire release workflow with all platforms:
   ```bash
   ./run-act-release.sh --local
   ```

## Scoop Package Manager Support

The Scoop manifest in `scoop.md` already includes configuration for both 64-bit and 32-bit Windows builds. When a release is created, the Windows 32bit build will be included in the release assets and can be installed via Scoop.

## Notes and Recommendations

1. **Cross-Compilation**: The actual building of Windows 32bit binaries happens on GitHub's Windows runners, not locally on macOS.

2. **Testing Strategy**: 
   - Use `act` for workflow validation and simulation
   - For actual binary testing, rely on GitHub Actions or a Windows environment

3. **Compatibility**: 
   - Windows 32bit support is important for older Windows systems
   - Consider testing the Windows 32bit build on actual 32bit Windows systems if possible

4. **Maintenance**: 
   - Keep the Windows 32bit build enabled in future releases
   - Monitor for any issues specific to the 32bit build
