# Publishing UUID CLI Tool to Scoop

This document provides instructions for publishing the UUID CLI tool to [Scoop](https://scoop.sh/), the command-line installer for Windows.

## Prerequisites

Before publishing to Scoop, ensure you have:

1. A GitHub repository for your project with:
   - Tagged releases
   - A README.md file
   - A LICENSE file

2. Scoop installed on your Windows system:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   irm get.scoop.sh | iex
   ```

3. A compiled Windows binary (preferably a portable executable)

## Creating a Scoop Manifest

Scoop packages are defined by JSON manifest files that specify how to install your software.

### Option 1: Submit to the Main Scoop Bucket

For widely-used tools that meet Scoop's criteria:

1. Fork the [ScoopInstaller/Main](https://github.com/ScoopInstaller/Main) repository

2. Create a new manifest file named `uuid.json` with the following content:

   ```json
   {
       "version": "1.0.0",
       "description": "CLI tool for generating UUIDs of different versions",
       "homepage": "https://github.com/antruongnguyen/uuid",
       "license": "MIT",
       "architecture": {
           "64bit": {
               "url": "https://github.com/antruongnguyen/uuid/releases/download/v1.0.0/uuid-x86_64-pc-windows-msvc.zip",
               "hash": "SHA256_HASH_OF_YOUR_ZIP_FILE"
           },
           "32bit": {
               "url": "https://github.com/antruongnguyen/uuid/releases/download/v1.0.0/uuid-i686-pc-windows-msvc.zip",
               "hash": "SHA256_HASH_OF_YOUR_ZIP_FILE"
           }
       },
       "bin": "uuid.exe",
       "checkver": "github",
       "autoupdate": {
           "architecture": {
               "64bit": {
                   "url": "https://github.com/antruongnguyen/uuid/releases/download/v$version/uuid-x86_64-pc-windows-msvc.zip"
               },
               "32bit": {
                   "url": "https://github.com/antruongnguyen/uuid/releases/download/v$version/uuid-i686-pc-windows-msvc.zip"
               }
           }
       }
   }
   ```

3. Test your manifest locally:
   ```powershell
   scoop install path\to\uuid.json
   ```

4. Submit a pull request to the ScoopInstaller/Main repository

### Option 2: Create Your Own Bucket (Recommended for Personal Projects)

A bucket is your own Scoop repository:

1. Create a new GitHub repository named `scoop-uuid` (or any name you prefer)

2. Initialize it with a basic structure:
   ```
   scoop-uuid/
   ├── bucket/
   │   └── uuid.json
   └── README.md
   ```

3. Add your manifest file `uuid.json` to the bucket directory with the same content as above

4. Users can then install your package with:
   ```powershell
   scoop bucket add uuid https://github.com/antruongnguyen/scoop-uuid
   scoop install uuid
   ```

## Preparing Your Release Files

For Scoop, you should:

1. Create a GitHub release with versioned assets
2. Include Windows binaries in a ZIP file
3. Make sure the ZIP structure matches what's expected in your manifest
4. Generate SHA256 hashes for your ZIP files

## Generating the SHA256 Hash

To get the SHA256 hash for your ZIP file:

1. In PowerShell:
   ```powershell
   Get-FileHash -Algorithm SHA256 -Path path\to\uuid-x86_64-pc-windows-msvc.zip
   ```

2. Or in Command Prompt:
   ```cmd
   certutil -hashfile path\to\uuid-x86_64-pc-windows-msvc.zip SHA256
   ```

3. Use the resulting hash in your manifest

## Updating Your Manifest

When you release a new version:

1. Update the version, URL, and hash in your manifest
2. If using the `checkver` and `autoupdate` properties correctly, you can use `scoop update` to automatically update the manifest
3. If using your own bucket, commit and push the changes
4. If in the main bucket, submit a new pull request

## Best Practices

1. Use the `checkver` property to allow automatic version checking
2. Use the `autoupdate` property to simplify updates
3. Include both 32-bit and 64-bit versions if possible
4. Keep your binaries portable (no installers)
5. Follow Scoop's [contribution guidelines](https://github.com/ScoopInstaller/Scoop/wiki/Contributing-Guidelines) if submitting to the main bucket

## Troubleshooting

If users encounter issues with your manifest:

1. They can try `scoop status` to check for problems
2. Use `scoop install -d uuid` for detailed installation logs
3. Report issues on your GitHub repository

## Resources

- [Scoop Wiki](https://github.com/ScoopInstaller/Scoop/wiki)
- [Scoop App Manifest Reference](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
- [Scoop Buckets](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
