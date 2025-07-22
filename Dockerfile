# syntax=docker/dockerfile:1
FROM --platform=linux/arm64 ubuntu:22.04

# Install necessary packages and QEMU for x86 emulation
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        ca-certificates \
        qemu-user-static \
        binfmt-support && \
    # Manually download and install SteamCMD
    mkdir -p /opt/steamcmd && \
    cd /opt/steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    chmod +x /opt/steamcmd/steamcmd.sh && \
    ln -s /opt/steamcmd/steamcmd.sh /usr/local/bin/steamcmd && \
    # Clean up
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/usr/local/bin"

WORKDIR /steamcmd

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
