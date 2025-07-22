# Abiotic Factor Linux Docker (ARM64)
For operating a dedicated server in Docker on ARM64 architecture (such as Apple Silicon Macs, ARM64 Linux servers, etc.).
The container runs the native Linux server binaries directly without Wine.

## Requirements
- ARM64-compatible host system (Apple Silicon Mac, ARM64 Linux server, etc.)
- Docker with ARM64 support
- SteamCMD must support downloading Linux ARM64 binaries for Abiotic Factor

**Note**: This version requires that Abiotic Factor provides native Linux ARM64 server binaries. If the game only provides x86_64 Linux binaries, you may need to use emulation or a different approach.

## Setup
1. Create a new empty directory in any location with enough storage space.
2. Create a file named `docker-compose.yml` and copy the content of [`docker-compose.yml.example`](docker-compose.yml.example) into it.
3. In the `docker-compose.yml` file, the environment variables `ServerPassword` and `SteamServerName` should be adjusted.
4. Setup and start via docker-compose by running the command `docker-compose up -d`.
    * This will run the server in the background and autostart it whenever the docker daemon starts. If you do not want this, remove `-d` from the command above.
    * This will download the Dedicated Server binaries and game files to the `gamefiles` directory.
    * Persistent save file data will be written to the `data` directory.

## Building for ARM64
If you need to build the container image yourself:

### Using the build script:
- **Linux/macOS**: `chmod +x build-arm64.sh && ./build-arm64.sh`
- **Windows PowerShell**: `.\build-arm64.ps1`

### Manual build:
```bash
docker buildx build --platform linux/arm64 -t abiotic-factor-linux-docker:arm64-latest .
```

Make sure you have Docker Buildx enabled for multi-platform builds.

## Update
There are two ways to update the game server:

1. By setting the `AutoUpdate` environment variable to `true`. This checks for updates every time the container is started.
2. By deleting the `gamefiles` directory while the server is turned off.

### Updating the container
Sometimes, changes to this container image are necessary. To apply these:

1. Merge the content of `docker-compose.yml` with any changes made from [`docker-compose.yml.example`](docker-compose.yml.example).
2. Run `docker-compose pull` to download an updated version of the container image.

## Configuration
An example configuration for docker-compose can be found in the `docker-compose.yml` file.
In addition to the default settings, which can be set via the environment variables, further arguments can be specified via the `AdditionalArgs` environment variable.

Possible launch parameters and further information on the dedicated servers for Abiotic Factor can be found [here](https://github.com/DFJacob/AbioticFactorDedicatedServer/wiki/Technical-%E2%80%90-Launch-Parameters).

## Credits
Thanks to @sirwillis92 for finding a solution to the startup problem with the `LogOnline: Warning: OSS: Async task 'FOnlineAsyncTaskSteamCreateServer bWasSuccessful: 0' failed in 15` message.

**ARM64 Conversion Notes**: This version has been converted to run natively on ARM64 architecture by removing Wine dependency and using Linux server binaries directly. This should provide better performance on ARM64 systems but requires that the game provides native Linux ARM64 server binaries.