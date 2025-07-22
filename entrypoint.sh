SetUsePerfThreads="-useperfthreads "
if [[ $UsePerfThreads == "false" ]]; then
    SetUsePerfThreads=""
fi

SetNoAsyncLoadingThread="-NoAsyncLoadingThread "
if [[ $NoAsyncLoadingThread == "false" ]]; then
    SetNoAsyncLoadingThread=""
fi

MaxServerPlayers="${MaxServerPlayers:-6}"
Port="${Port:-7777}"
QueryPort="${QueryPort:-27015}"
ServerPassword="${ServerPassword:-password}"
SteamServerName="${SteamServerName:-LinuxServer}"
WorldSaveName="${WorldSaveName:-Cascade}"
AdditionalArgs="${AdditionalArgs:-}"

# Check for updates/perform initial installation
if [ ! -d "/server/AbioticFactor/Binaries/Linux" ] || [[ $AutoUpdate == "true" ]]; then
    echo "Downloading/updating Abiotic Factor server files for Linux..."
    steamcmd \
    +@sSteamCmdForcePlatformType linux \
    +force_install_dir /server \
    +login anonymous \
    +app_update 2857200 validate \
    +quit
fi

# Check if Linux server binary exists
if [ ! -f "/server/AbioticFactor/Binaries/Linux/AbioticFactorServer-Linux-Shipping" ]; then
    echo "ERROR: Linux server binary not found!"
    echo "This may mean that Abiotic Factor doesn't provide Linux server binaries."
    echo "Path checked: /server/AbioticFactor/Binaries/Linux/AbioticFactorServer-Linux-Shipping"
    echo "Available binaries:"
    find /server -name "*Server*" -type f 2>/dev/null || echo "No server binaries found"
    echo ""
    echo "Checking for Windows binaries as fallback..."
    if [ -f "/server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe" ]; then
        echo "Windows server binary found, but this ARM64 container doesn't support Wine."
        echo "You may need to use the original x86_64 container with Wine instead."
    fi
    exit 1
fi

# Make sure the binary is executable
chmod +x /server/AbioticFactor/Binaries/Linux/AbioticFactorServer-Linux-Shipping

# Check if the binary is x86_64 and warn about emulation
BINARY_ARCH=$(file /server/AbioticFactor/Binaries/Linux/AbioticFactorServer-Linux-Shipping | grep -o "x86-64\|aarch64\|ARM aarch64")
if echo "$BINARY_ARCH" | grep -q "x86-64"; then
    echo "WARNING: Server binary is x86_64 and will run through QEMU emulation on ARM64."
    echo "Performance may be reduced. Consider using a native x86_64 host if possible."
elif echo "$BINARY_ARCH" | grep -q -E "aarch64|ARM aarch64"; then
    echo "INFO: Server binary is native ARM64 - optimal performance expected."
else
    echo "INFO: Could not determine server binary architecture."
fi

echo "Starting Abiotic Factor Linux server..."
pushd /server/AbioticFactor/Binaries/Linux > /dev/null
./AbioticFactorServer-Linux-Shipping $SetUsePerfThreads$SetNoAsyncLoadingThread-MaxServerPlayers=$MaxServerPlayers \
    -PORT=$Port -QueryPort=$QueryPort -ServerPassword=$ServerPassword \
    -SteamServerName="$SteamServerName" -WorldSaveName="$WorldSaveName" -tcp $AdditionalArgs
popd > /dev/null
