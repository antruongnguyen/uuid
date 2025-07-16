# UUID CLI Tool

[![CI](https://github.com/antruongnguyen/uuid/actions/workflows/ci.yml/badge.svg)](https://github.com/antruongnguyen/uuid/actions/workflows/ci.yml)
[![Release](https://github.com/antruongnguyen/uuid/actions/workflows/release.yml/badge.svg)](https://github.com/antruongnguyen/uuid/actions/workflows/release.yml)

A command-line tool for generating UUIDs of different versions with various formatting options.

## Features

- Generate UUIDs of different versions:
  - v1: Version 1 UUIDs using a timestamp and monotonic counter
  - v3: Version 3 UUIDs based on the MD5 hash of some data
  - v4: Version 4 UUIDs with random data (default)
  - v5: Version 5 UUIDs based on the SHA1 hash of some data
  - v6: Version 6 UUIDs using a timestamp and monotonic counter
  - v7: Version 7 UUIDs using a Unix timestamp
  - v8: Version 8 UUIDs using user-defined data
- Convert UUIDs to uppercase
- Generate multiple UUIDs at once
- Copy generated UUIDs to the clipboard*

*Note: Clipboard support is disabled for ARM64 Linux builds due to cross-compilation limitations with X11 libraries.

## Installation

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install) (1.70.0 or later)
- Cargo (included with Rust)

### Building from Source

1. Clone the repository:
   ```
   git clone https://github.com/antruongnguyen/uuid.git
   cd uuid
   ```

2. Build the project:
   ```
   cargo build --release
   ```

3. The compiled binary will be available at `target/release/uuid`

4. (Optional) Add to your PATH for easier access:
   ```
   # On Linux/macOS
   cp target/release/uuid /usr/local/bin/

   # On Windows, add the location to your PATH environment variable
   ```

### Using Homebrew (macOS/Linux)

You can install the UUID CLI tool using Homebrew:

```bash
brew tap antruongnguyen/uuid
brew install uuid
```

### Using Scoop (Windows)

You can install the UUID CLI tool using Scoop:

```powershell
scoop bucket add uuid https://github.com/antruongnguyen/scoop-uuid
scoop install uuid
```

## Usage

### Basic Usage

Generate a random UUID (v4 by default):
```
uuid
```

### Command-line Options

```
Usage: uuid [OPTIONS]

Options:
  -t, --type <VERSION>    UUID version to generate [default: v4] [possible values: v1, v3, v4, v5, v6, v7, v8]
  -u, --uppercase         Convert UUID to uppercase
  -c, --count <COUNT>     Number of UUIDs to generate [default: 1]
  -p, --copy              Copy the generated UUID to clipboard (only works with count=1)
  -n, --namespace <NAMESPACE>  Namespace for v3 and v5 UUIDs (required for these versions)
  -a, --name <NAME>       Name for v3 and v5 UUIDs (required for these versions)
  -d, --data <DATA>       User-defined data for v8 UUIDs (required for v8)
  -h, --help              Print help
```

### Examples

1. Generate a v4 UUID (random):
   ```
   uuid
   ```
   Output: `f47ac10b-58cc-4372-a567-0e02b2c3d479`

2. Generate a v1 UUID (timestamp-based):
   ```
   uuid -t v1
   ```
   Output: `550e8400-e29b-11d4-a716-446655440000`

3. Generate a UUID in uppercase:
   ```
   uuid -u
   ```
   Output: `F47AC10B-58CC-4372-A567-0E02B2C3D479`

4. Generate 5 UUIDs:
   ```
   uuid -c 5
   ```
   Output:
   ```
   f47ac10b-58cc-4372-a567-0e02b2c3d479
   550e8400-e29b-11d4-a716-446655440000
   6ba7b810-9dad-11d1-80b4-00c04fd430c8
   6ba7b811-9dad-11d1-80b4-00c04fd430c8
   6ba7b812-9dad-11d1-80b4-00c04fd430c8
   ```

5. Generate a v3 UUID (namespace + name with MD5):
   ```
   uuid -t v3 -n "6ba7b810-9dad-11d1-80b4-00c04fd430c8" -a "example.com"
   ```
   Output: `5df41881-3aed-3515-88a7-2f4a814cf09e`

6. Generate a v5 UUID (namespace + name with SHA1):
   ```
   uuid -t v5 -n "6ba7b810-9dad-11d1-80b4-00c04fd430c8" -a "example.com"
   ```
   Output: `2ed6657d-e927-568b-95e1-2665a8aea6a2`

7. Generate a v8 UUID (user-defined):
   ```
   uuid -t v8 -d "custom-data-string"
   ```
   Output: `6375-7374-8f6d-8064-6174-612d-7374-7269`

8. Copy a UUID to clipboard:
   ```
   uuid -p
   ```
   Output: `f47ac10b-58cc-4372-a567-0e02b2c3d479` (also copied to clipboard)

## Testing

Run the tests with:
```
cargo test
```

## Code Formatting

This project uses [rustfmt](https://github.com/rust-lang/rustfmt) to maintain consistent code formatting. The formatting rules are defined in the `rustfmt.toml` file.

> **Note:** Some advanced formatting options are commented out in `rustfmt.toml` because they require the nightly Rust channel. If you want to use these features, switch to the nightly channel with `rustup default nightly`.

### Formatting Code Manually

To format your code manually, run:
```
cargo fmt
```

To check if your code is properly formatted without making changes:
```
cargo fmt -- --check
```

### Pre-commit Hook

A pre-commit hook is provided to automatically format your code before each commit. To set it up:

```bash
# Copy the hook to the git hooks directory
cp hooks/pre-commit .git/hooks/
# Make sure it's executable
chmod +x .git/hooks/pre-commit
```

### CI Integration

The CI pipeline automatically checks that all code is properly formatted. If the formatting check fails, the build will fail.

## Cross-platform Support

This tool works on:
- macOS (x86_64 and ARM64) - Full feature support
- Linux (x86_64) - Full feature support  
- Linux (ARM64) - **Clipboard support disabled**
- Windows (both 64-bit and 32-bit) - Full feature support

### ARM64 Linux Clipboard Limitation

Clipboard support is disabled for ARM64 Linux builds due to cross-compilation limitations with X11 system libraries. Here's why:

#### Technical Explanation

The `clipboard` crate depends on native X11 libraries (`libxcb`, `libxcb-render`, `libx11`, etc.) which creates cross-compilation challenges:

1. **Architecture Mismatch**: GitHub Actions runners are x86_64, but we need ARM64 libraries
2. **Linking Errors**: Can't link ARM64 object files with x86_64 X11 libraries
3. **Cross-compilation Complexity**: ARM64 X11 libraries aren't available in standard cross-compilation containers

#### Workaround for ARM64 Linux Users

If you need clipboard functionality on ARM64 Linux, you can:

```bash
# Pipe output to system clipboard tools
uuid | xclip -selection clipboard

# Or use pbcopy on some systems
uuid | pbcopy
```

#### Why This Approach Makes Sense

- **Practical Impact**: ARM64 Linux systems often run headless without X11
- **Core Functionality**: UUID generation works perfectly without clipboard
- **Clean Architecture**: Optional features allow targeted builds for different environments

For more information about Windows 32-bit support, see [README-windows-32bit.md](README-windows-32bit.md).
For more information about ARM64 Linux support, see [README-arm64-linux.md](README-arm64-linux.md).

## Continuous Integration and Deployment

This project uses GitHub Actions for continuous integration and deployment:

- **CI Workflow**: Automatically runs tests on all supported platforms (macOS, Linux, Windows) for every push and pull request.
- **Release Workflow**: Automatically builds binaries for all supported platforms and creates a GitHub release when a new tag is pushed.
- **Dependency Updates**: Uses Dependabot to automatically check for updates to dependencies and GitHub Actions workflows.
- **Documentation Updates**: Automatically updates the dependency versions in documentation when Cargo.toml changes.

### Testing Workflows Locally

You can test the GitHub Actions workflows locally using the `act` tool:

```bash
# Test the entire release workflow
./run-act-release.sh --local

# Test a specific platform (e.g., Windows 32-bit)
./run-act-release.sh --local -j simulate-platforms --matrix target:i686-pc-windows-msvc
```

For more information about testing workflows locally:
- See [act-setup.md](act-setup.md) for setting up `act`
- See [README-act-release.md](README-act-release.md) for testing the release workflow
- See [README-windows-32bit.md](README-windows-32bit.md) for Windows 32-bit specific information

### Creating a Release

To create a new release:

1. Update the version in `Cargo.toml`
2. Commit the changes
3. Tag the commit with a version number (e.g., `v0.1.0`)
4. Push the tag to GitHub

The release workflow will automatically:
- Build binaries for all supported platforms
- Create a GitHub release with the binaries
- Generate package manager assets (Homebrew formula and Scoop manifest)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
