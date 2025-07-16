# Setting up `act` for Local GitHub Actions Testing

This guide will help you set up and use `act` to test GitHub Actions workflows locally on macOS with Apple Silicon (M3).

## Installation

First, install `act` using Homebrew:

```bash
brew install act
```

## Basic Configuration

`act` requires Docker to run. Make sure Docker Desktop is installed and running on your Mac.

## Testing the Release Workflow

The release workflow in this repository is triggered by pushing a tag. To test it locally:

1. Create a `.actrc` file in the repository root with the following content:

```
-P ubuntu-latest=catthehacker/ubuntu:act-latest
-P macos-latest=catthehacker/ubuntu:act-latest
-P windows-latest=catthehacker/ubuntu:act-latest
```

2. Create a `.secrets` file (add to .gitignore) with any secrets needed:

```
GITHUB_TOKEN=your_github_token
```

3. Create a local event file `release-event.json`:

```json
{
  "ref": "refs/tags/v0.0.0-test",
  "ref_name": "v0.0.0-test"
}
```

4. Run the workflow with:

```bash
# Use the provided script
./run-act-release.sh

# Or run manually
act push --eventpath release-event.json --secret-file .secrets
```

5. For better compatibility, use the simplified local workflow:

```bash
# Use the provided script with --local flag
./run-act-release.sh --local

# Or run manually
act push --eventpath release-event.json --secret-file .secrets -W .github/workflows/release-local.yml
```

## Notes for Apple Silicon (M3)

Since you're using an Apple M3 chip, you might encounter some platform-specific issues:
- Docker images will run in emulation mode for x86_64 images
- This might cause some performance degradation
- For best results, use ARM64-compatible Docker images when possible

## Customizing the Test

You can modify the test by:
- Changing the tag version in the event file
- Testing specific jobs: `./run-act-release.sh --local -j build-native`
- Testing specific platforms: `./run-act-release.sh --local -j simulate-platforms --matrix target:<platform>`

### Testing Specific Platforms

To test a specific platform, use the following commands:

```bash
# Test Windows 32-bit (i686) build
./run-act-release.sh --local -j simulate-platforms --matrix target:i686-pc-windows-msvc

# Test Windows 64-bit (x86_64) build
./run-act-release.sh --local -j simulate-platforms --matrix target:x86_64-pc-windows-msvc

# Test macOS x86_64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:x86_64-apple-darwin

# Test macOS ARM64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:aarch64-apple-darwin

# Test Linux x86_64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:x86_64-unknown-linux-gnu

# Test Linux ARM64 build
./run-act-release.sh --local -j simulate-platforms --matrix target:aarch64-unknown-linux-gnu
```

For more detailed information about testing the release workflow, see [README-act-release.md](README-act-release.md).
