# UUID Scoop Bucket

A [Scoop](https://scoop.sh/) bucket for the UUID CLI tool - a command-line utility for generating UUIDs of different versions.

## Installation

### Install Latest Version

```powershell
# Add the bucket
scoop bucket add uuid https://github.com/antruongnguyen/scoop-uuid

# Install uuid (latest version)
scoop install uuid
```

### Install Specific Version

```powershell
# Add the bucket first
scoop bucket add uuid https://github.com/antruongnguyen/scoop-uuid

# Method 1: Install from specific bucket version
# Navigate to bucket directory and checkout specific version
cd $env:SCOOP\buckets\uuid
git checkout v1.0.0  # Replace with desired version
scoop install uuid
git checkout main     # Return to latest

# Method 2: Install directly from specific commit/tag
scoop install https://raw.githubusercontent.com/antruongnguyen/scoop-uuid/v1.0.0/uuid.json
```

## Usage

```powershell
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

# Copy to clipboard
uuid -p
```

## Features

- Generate UUIDs of different versions (v1, v3, v4, v5, v6, v7, v8)
- Convert UUIDs to uppercase
- Generate multiple UUIDs at once
- Windows support (32-bit and 64-bit)
- Copy generated UUIDs to clipboard

## Version Information

- **Current Version**: Check with `scoop info uuid`
- **Source**: [antruongnguyen/uuid](https://github.com/antruongnguyen/uuid)
- **License**: MIT

## Updating

```powershell
# Update the bucket and package
scoop update
scoop update uuid
```

## Version Management

### Check Current Version

```powershell
# Check installed version
scoop info uuid

# Check available versions in the bucket
cd $env:SCOOP\buckets\uuid
git tag --list
```

### Rollback to Previous Version

```powershell
# Method 1: Uninstall and reinstall specific version
scoop uninstall uuid
scoop install https://raw.githubusercontent.com/antruongnguyen/scoop-uuid/v1.0.0/uuid.json

# Method 2: Use bucket's version history
cd $env:SCOOP\buckets\uuid
git checkout v1.0.0  # Replace with desired version
scoop uninstall uuid
scoop install uuid
git checkout main     # Return to latest

# Method 3: Reset to specific version (if you have issues)
scoop reset uuid@v1.0.0  # If multiple versions are cached
```

### Available Versions

Check the [releases page](https://github.com/antruongnguyen/uuid/releases) or use:

```powershell
# List all available version tags
cd $env:SCOOP\buckets\uuid
git tag --list --sort=-version:refname

# Or check GitHub releases
scoop checkver uuid
```

## Uninstallation

```powershell
# Remove the package
scoop uninstall uuid

# Remove the bucket (optional)
scoop bucket rm uuid
```

## Auto-Update Support

This bucket supports automatic updates via Scoop's built-in update mechanism. When new versions are released, you can update with:

```powershell
scoop update uuid
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

## About Scoop Buckets

This is a personal Scoop bucket. For more information about Scoop buckets, visit the [official documentation](https://github.com/ScoopInstaller/Scoop/wiki/Buckets).