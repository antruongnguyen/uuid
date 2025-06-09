# Publishing UUID CLI Tool to Homebrew

This document provides instructions for publishing the UUID CLI tool to [Homebrew](https://brew.sh/), the package manager for macOS and Linux.

## Prerequisites

Before publishing to Homebrew, ensure you have:

1. A GitHub repository for your project with:
   - Tagged releases
   - A README.md file
   - A LICENSE file

2. Homebrew installed on your system:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. A compiled binary that works on macOS and Linux

## Preparing Your Formula

Homebrew packages are defined by "formulae" - Ruby scripts that specify how to install your software.

### Option 1: Submit to Homebrew Core (Official Repository)

For widely-used tools that meet Homebrew's criteria:

1. Fork the [Homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core) repository

2. Create a new formula in the `Formula` directory with the filename `uuid.rb`:

   ```ruby
   class Uuid < Formula
     desc "CLI tool for generating UUIDs of different versions"
     homepage "https://github.com/antruongnguyen/uuid"
     url "https://github.com/antruongnguyen/uuid/archive/refs/tags/v1.0.0.tar.gz"
     sha256 "YOUR_TARBALL_SHA256_CHECKSUM"
     license "MIT"

     depends_on "rust" => :build

     def install
       system "cargo", "install", "--locked", "--root", prefix, "--path", "."
       # Install any additional files like man pages or completion scripts
       # man.install "man/uuid.1"
       # bash_completion.install "completions/uuid.bash"
       # zsh_completion.install "completions/uuid.zsh"
       # fish_completion.install "completions/uuid.fish"
     end

     test do
       assert_match /[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/, shell_output("#{bin}/uuid")
     end
   end
   ```

3. Test your formula locally:
   ```bash
   brew install --build-from-source ./uuid.rb
   ```

4. Submit a pull request to the Homebrew/homebrew-core repository

### Option 2: Create Your Own Tap (Recommended for Personal Projects)

A tap is your own Homebrew repository:

1. Create a new GitHub repository named `homebrew-uuid` (the prefix `homebrew-` is required)

2. Add your formula file `uuid.rb` to this repository with the same content as above

3. Users can then install your package with:
   ```bash
   brew tap antruongnguyen/uuid
   brew install uuid
   ```

## Generating the SHA256 Checksum

To get the SHA256 checksum for your tarball:

1. Create a release on GitHub and note the tarball URL
2. Download the tarball and generate the checksum:
   ```bash
   curl -L https://github.com/antruongnguyen/uuid/archive/refs/tags/v1.0.0.tar.gz -o uuid-1.0.0.tar.gz
   shasum -a 256 uuid-1.0.0.tar.gz
   ```
3. Use the resulting checksum in your formula

## Updating Your Formula

When you release a new version:

1. Update the URL and SHA256 in your formula
2. If using your own tap, commit and push the changes
3. If in homebrew-core, submit a new pull request

## Best Practices

1. Include comprehensive tests in your formula
2. Provide completion scripts for popular shells
3. Include man pages if appropriate
4. Ensure your binary is statically linked or has minimal dependencies
5. Follow Homebrew's [contribution guidelines](https://github.com/Homebrew/brew/blob/master/CONTRIBUTING.md) if submitting to homebrew-core

## Troubleshooting

If users encounter issues with your formula:

1. They can try `brew doctor` to diagnose Homebrew issues
2. Use `brew install --verbose --debug uuid` for detailed installation logs
3. Report issues on your GitHub repository

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Ruby API documentation](https://rubydoc.brew.sh/)
- [Homebrew Taps documentation](https://docs.brew.sh/Taps)
