# UUID CLI Tool Requirements

This document outlines the requirements for building, running, and developing the UUID CLI tool.

## System Requirements

The UUID CLI tool is designed to run on:

- **macOS** (10.13 High Sierra or later)
- **Linux** (most modern distributions)
- **Windows** (Windows 10 or later)

## Runtime Dependencies

The compiled binary has no external runtime dependencies as all required libraries are statically linked.

## Build Dependencies

To build the project from source, you need:

1. **Rust Toolchain**:
   - Rust version 1.70.0 or later
   - Cargo (included with Rust)
   - rustup (recommended for managing Rust versions)

2. **Development Tools**:
   - A C compiler (for native dependencies):
     - **Windows**: MSVC build tools
     - **macOS**: Xcode Command Line Tools
     - **Linux**: GCC or Clang

## Project Dependencies

The project relies on the following Rust crates:

1. **uuid** (v1.17.0):
   - Features enabled: v1, v3, v4, v5, v6, v7, v8, fast-rng, macro-diagnostics
   - Purpose: Core functionality for UUID generation

2. **clap** (v4.5.41):
   - Features enabled: derive
   - Purpose: Command-line argument parsing

3. **clipboard** (v0.5.0):
   - Optional dependency (enabled by default via `clipboard-support` feature)
   - Purpose: Cross-platform clipboard access
   - Note: Disabled for ARM64 Linux builds due to X11 library dependencies

## Feature Flags

The project supports the following feature flags:

1. **default**: Includes `clipboard-support` feature
2. **clipboard-support**: Enables clipboard functionality via the `clipboard` crate

To build without clipboard support:
```bash
cargo build --no-default-features
```

## Development Requirements

For development work on this project, the following additional tools are recommended:

1. **Code Editor/IDE**:
   - Visual Studio Code with rust-analyzer extension
   - IntelliJ IDEA with Rust plugin
   - Or any other Rust-compatible editor

2. **Testing Tools**:
   - Cargo's built-in testing framework

3. **Version Control**:
   - Git

4. **Documentation**:
   - rustdoc (included with Rust)

## Building for Different Platforms

### Cross-Compilation

To build for platforms other than your development machine:

1. **For Windows from Linux/macOS**:
   ```
   rustup target add x86_64-pc-windows-gnu
   cargo build --release --target x86_64-pc-windows-gnu
   ```

2. **For macOS from Linux/Windows** (requires a macOS machine for final builds):
   ```
   rustup target add x86_64-apple-darwin
   cargo build --release --target x86_64-apple-darwin
   ```

3. **For Linux from Windows/macOS**:
   ```
   rustup target add x86_64-unknown-linux-gnu
   cargo build --release --target x86_64-unknown-linux-gnu
   ```

## Minimum Rust Version

This project requires Rust 1.70.0 or later due to the use of certain features in the dependencies.