#!/bin/bash

# ==========================================
# MINECRAFT SERVER BUILDER 1.21.1 (FABRIC)
# Automated for Termux & Codespaces
# ==========================================

echo ">>> 1. SETTING UP ENVIRONMENT..."
# Detect OS and install Java 21
if [ -d "/data/data/com.termux/files" ]; then
    pkg update -y && pkg install openjdk-21 wget git -y
else
    sudo apt-get update && sudo apt-get install openjdk-21-jre-headless wget git -y
fi

# Create Server Directory
mkdir -p mcserver/mods
cd mcserver

echo ">>> 2. INSTALLING FABRIC SERVER (1.21.1)..."
# Download Fabric Installer & Install Server
curl -OJ https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
java -jar fabric-installer-1.0.1.jar server -mcversion 1.21.1 -downloadMinecraft
echo "eula=true" > eula.txt
rm fabric-installer-1.0.1.jar

echo ">>> 3. DOWNLOADING MODS (Auto-Fetch)..."
cd mods

# Helper function to download from Modrinth CDN (Links target 1.21.1 stable versions)
download_mod() {
    wget -q --show-progress -O "$2" "$1"
    echo "Downloaded: $2"
}

# --- CORE ---
download_mod "https://cdn.modrinth.com/data/P7dR8mSH/versions/v0.100.8-1.21/fabric-api-0.100.8+1.21.jar" "fabric-api.jar"

# --- PERFORMANCE ---
download_mod "https://cdn.modrinth.com/data/hvFnDODi/versions/mc1.21-0.12.7/lithium-fabric-mc1.21-0.12.7.jar" "lithium.jar"
download_mod "https://cdn.modrinth.com/data/uXXizFIs/versions/0.7.0/ferritecore-7.0.0-fabric.jar" "ferritecore.jar"
download_mod "https://cdn.modrinth.com/data/nmDcB62a/versions/5.18.1+mc1.21.1/modernfix-fabric-5.18.1+mc1.21.1.jar" "modernfix.jar"

# --- CROSSPLAY (GEYSER) ---
# Always grabbing latest build from Geyser Jenkins for stability
wget -q --show-progress -O Geyser-Fabric.jar "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/fabric"
wget -q --show-progress -O Floodgate-Fabric.jar "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/fabric"
download_mod "https://cdn.modrinth.com/data/P1OZGk5p/versions/5.0.1/ViaVersion-5.0.1.jar" "ViaVersion.jar"

# --- WORLD GEN (BETTER MINECRAFT FEEL) ---
download_mod "https://cdn.modrinth.com/data/8oi3bsk5/versions/v2.5.4/Terralith_1.21_v2.5.4.jar" "Terralith.jar"
download_mod "https://cdn.modrinth.com/data/l51t70h5/versions/v5.4.2/Incendium_1.21_v5.4.2.jar" "Incendium.jar"
download_mod "https://cdn.modrinth.com/data/NYgfkD9E/versions/v1.2.7/Nullscape_1.21_v1.2.7.jar" "Nullscape.jar"

cd ..

echo ">>> 4. CREATING RUN SCRIPT..."
echo '#!/bin/bash' > start.sh
# Dynamic RAM allocation: 4GB for Termux, 2GB for Codespaces
if [ -d "/data/data/com.termux/files" ]; then
    echo 'java -Xms1024M -Xmx4096M -XX:+UseG1GC -jar fabric-server-launch.jar nogui' >> start.sh
else
    echo 'java -Xms1024M -Xmx2048M -XX:+UseG1GC -jar fabric-server-launch.jar nogui' >> start.sh
fi
chmod +x start.sh

echo ">>> SETUP COMPLETE!"
echo "Run './start.sh' to start your server."
