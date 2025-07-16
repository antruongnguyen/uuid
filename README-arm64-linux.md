# ARM64 Linux Build Support

This document provides information about the ARM64 Linux build support added to the UUID CLI tool.

## Changes Made

1. Enabled ARM64 Linux (aarch64-unknown-linux-gnu) build target in the release workflow:
   - Uncommented the ARM64 Linux build configuration in `.github/workflows/release.yml`
   - Added configuration for ARM64 Linux in `Cross.toml`
   - ARM64 Linux was already included in the simulation matrix in `.github/workflows/release-local.yml`

2. **Clipboard Support Limitation**: ARM64 Linux builds are compiled without clipboard support due to cross-compilation limitations with X11 system libraries.

## Clipboard Limitation for ARM64 Linux

### Why Clipboard Support is Disabled

The clipboard functionality is disabled for ARM64 Linux builds due to cross-compilation challenges:

#### Technical Root Cause
- The `clipboard` crate depends on X11 libraries (`libxcb`, `libxcb-render`, `libx11`, etc.)
- Cross-compilation from x86_64 GitHub runners to ARM64 Linux fails because:
  1. **Architecture Mismatch**: Need ARM64 X11 libraries but only x86_64 versions available
  2. **Linking Errors**: Can't link ARM64 object files with x86_64 X11 libraries
  3. **Container Limitations**: ARM64 X11 libraries aren't available in cross-compilation containers

#### Build Solution
- ARM64 Linux builds use `cross build --no-default-features` to exclude clipboard support
- All other platforms retain full clipboard functionality

### Workarounds for ARM64 Linux Users

If you need clipboard functionality on ARM64 Linux:

```bash
# Use system clipboard tools
uuid | xclip -selection clipboard

# Or on some systems
uuid | pbcopy

# For Wayland systems
uuid | wl-copy
```

### Why This Approach Makes Sense

1. **Practical Impact**: Many ARM64 Linux systems run headless without X11
2. **Core Functionality**: UUID generation works perfectly without clipboard
3. **Reliability**: Ensures consistent, successful builds across all platforms
4. **Clean Architecture**: Optional features allow targeted builds for different environments

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