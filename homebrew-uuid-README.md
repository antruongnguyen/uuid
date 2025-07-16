# UUID Homebrew Tap

A [Homebrew](https://brew.sh/) tap for the UUID CLI tool - a command-line utility for generating UUIDs of different versions.

## Installation

### Install Latest Version

```bash
# Add the tap
brew tap antruongnguyen/uuid

# Install uuid (latest version)
brew install uuid
```

### Install Specific Version

```bash
# Add the tap first
brew tap antruongnguyen/uuid

# Install a specific version by checking out the version tag
cd $(brew --repository antruongnguyen/uuid)
git checkout v1.0.0  # Replace with desired version
brew install uuid
git checkout main     # Return to latest

# Or install directly from a specific commit/tag
brew install https://raw.githubusercontent.com/antruongnguyen/homebrew-uuid/v1.0.0/uuid.rb
```

## Usage

```bash
# Generate a random UUID (v4)
uuid

# Generate a UUID with uppercase output  
uuid -u

# Generate multiple UUIDs
uuid -c 5

# Generate different UUID versions
uuid -t v1  # timestamp-based
uuid -t v3 -n "namespace-uuid" -a "example.com"  # MD5-based
uuid -t v5 -n "namespace-uuid" -a "example.com"  # SHA1-based
uuid -t v7  # Unix timestamp-based

# Copy to clipboard (not available on ARM64 Linux)
uuid -p
```

## Features

- Generate UUIDs of different versions (v1, v3, v4, v5, v6, v7, v8)
- Convert UUIDs to uppercase
- Generate multiple UUIDs at once
- Cross-platform support (macOS, Linux, Windows)
- Copy generated UUIDs to clipboard*

*Note: Clipboard support is disabled for ARM64 Linux builds due to cross-compilation limitations.

## Version Information

- **Current Version**: Check with `brew info uuid`
- **Source**: [antruongnguyen/uuid](https://github.com/antruongnguyen/uuid)
- **License**: MIT

## Updating

```bash
# Update the tap and package
brew update
brew upgrade uuid
```

## Version Management

### Check Current Version

```bash
# Check installed version
brew info uuid

# Check available versions in the tap
cd $(brew --repository antruongnguyen/uuid)
git tag --list
```

### Rollback to Previous Version

```bash
# Method 1: Uninstall and reinstall specific version
brew uninstall uuid
brew install https://raw.githubusercontent.com/antruongnguyen/homebrew-uuid/v1.0.0/uuid.rb

# Method 2: Use tap's version history
cd $(brew --repository antruongnguyen/uuid)
git checkout v1.0.0  # Replace with desired version
brew uninstall uuid
brew install uuid
git checkout main     # Return to latest

# Method 3: Link to specific version if you have multiple installed
brew link uuid@1.0.0  # If versioned formula exists
```

### Available Versions

Check the [releases page](https://github.com/antruongnguyen/uuid/releases) or use:

```bash
# List all available version tags
cd $(brew --repository antruongnguyen/uuid)
git tag --list --sort=-version:refname
```

## Uninstallation

```bash
# Remove the package
brew uninstall uuid

# Remove the tap (optional)
brew untap antruongnguyen/uuid
```

## Support

For issues, feature requests, or contributions:
- **Repository**: [antruongnguyen/uuid](https://github.com/antruongnguyen/uuid)
- **Issues**: [GitHub Issues](https://github.com/antruongnguyen/uuid/issues)

## Credits and Special Thanks

This CLI tool is built on top of the excellent **uuid** Rust library:

- **Library**: [uuid-rs/uuid](https://github.com/uuid-rs/uuid)
- **Special Thanks**: To all the maintainers and contributors of the uuid-rs library for providing a robust, well-maintained UUID generation library for Rust
- **License**: The uuid library is licensed under Apache-2.0 OR MIT

We are grateful for the hard work and dedication of the uuid-rs team, which makes this CLI tool possible. Their implementation provides comprehensive UUID generation capabilities with excellent performance and standards compliance.

## About Homebrew Taps

This is a personal Homebrew tap. For more information about Homebrew taps, visit the [official documentation](https://docs.brew.sh/Taps).