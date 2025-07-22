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
    echo "This may mean that Abiotic Factor doesn't provide ARM64 Linux server binaries."
    echo "Path checked: /server/AbioticFactor/Binaries/Linux/AbioticFactorServer-Linux-Shipping"
    echo "Available binaries:"
    find /server -name "*Server*" -type f 2>/dev/null || echo "No server binaries found"
    exit 1
fi

# Make sure the binary is executable
chmod +x /server/AbioticFactor/Binaries/Linux/AbioticFactorServer-Linux-Shipping

echo "Starting Abiotic Factor Linux server..."
pushd /server/AbioticFactor/Binaries/Linux > /dev/null
./AbioticFactorServer-Linux-Shipping $SetUsePerfThreads$SetNoAsyncLoadingThread-MaxServerPlayers=$MaxServerPlayers \
    -PORT=$Port -QueryPort=$QueryPort -ServerPassword=$ServerPassword \
    -SteamServerName="$SteamServerName" -WorldSaveName="$WorldSaveName" -tcp $AdditionalArgs
popd > /dev/null
