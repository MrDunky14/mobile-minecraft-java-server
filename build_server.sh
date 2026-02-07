#!/bin/bash
# 🛠️ CODESPACES BUILD SCRIPT
# Downloads Fabric 1.21.1, Mods, and creates automation scripts.

echo ">>> [1/4] Setting up directories..."
mkdir -p server/mods
cd server

echo ">>> [2/4] Downloading Fabric 1.21.1 Server..."
curl -OJ https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
java -jar fabric-installer-1.0.1.jar server -mcversion 1.21.1 -downloadMinecraft
rm fabric-installer-1.0.1.jar
echo "eula=true" > eula.txt

echo ">>> [3/4] Downloading Mods (Performance + Geyser + Terralith)..."
cd mods
get_mod() { wget -q -O "$2" "$1" && echo "Downloaded: $2"; }

# Performance
get_mod "https://cdn.modrinth.com/data/P7dR8mSH/versions/v0.100.8-1.21/fabric-api-0.100.8+1.21.jar" "fabric-api.jar"
get_mod "https://cdn.modrinth.com/data/hvFnDODi/versions/mc1.21-0.12.7/lithium-fabric-mc1.21-0.12.7.jar" "lithium.jar"
get_mod "https://cdn.modrinth.com/data/uXXizFIs/versions/0.7.0/ferritecore-7.0.0-fabric.jar" "ferritecore.jar"
get_mod "https://cdn.modrinth.com/data/nmDcB62a/versions/5.18.1+mc1.21.1/modernfix-fabric-5.18.1+mc1.21.1.jar" "modernfix.jar"

# Geyser (Bedrock Support)
get_mod "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/fabric" "Geyser-Fabric.jar"
get_mod "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/fabric" "Floodgate-Fabric.jar"
get_mod "https://cdn.modrinth.com/data/P1OZGk5p/versions/5.0.1/ViaVersion-5.0.1.jar" "ViaVersion.jar"
get_mod "https://cdn.modrinth.com/data/l60KzE50/versions/5.0.1/ViaBackwards-5.0.1.jar" "ViaBackwards.jar"

# World Gen
get_mod "https://cdn.modrinth.com/data/8oi3bsk5/versions/v2.5.4/Terralith_1.21_v2.5.4.jar" "Terralith.jar"
get_mod "https://cdn.modrinth.com/data/l51t70h5/versions/v5.4.2/Incendium_1.21_v5.4.2.jar" "Incendium.jar"
get_mod "https://cdn.modrinth.com/data/NYgfkD9E/versions/v1.2.7/Nullscape_1.21_v1.2.7.jar" "Nullscape.jar"

cd ..

echo ">>> [4/4] Creating Smart Scripts..."

# Create Backup Script
cat << 'EOF' > backup_gdrive.sh
#!/bin/bash
BACKUP_NAME="backup-$(date +%Y-%m-%d-%H%M).tar.gz"
REMOTE="gdrive:Minecraft_Backups"
echo ">>> [Backup] Zipping world..."
tar -czf $BACKUP_NAME world world_nether world_the_end config server.properties
echo ">>> [Backup] Uploading to Google Drive..."
if rclone listremotes | grep -q "gdrive:"; then
    rclone copy $BACKUP_NAME $REMOTE --progress
    rclone delete --min-age 7d $REMOTE
    rm $BACKUP_NAME
    echo ">>> [Backup] Complete!"
else
    echo ">>> [Error] Rclone not configured! Run 'rclone config' first."
fi
EOF
chmod +x backup_gdrive.sh

# Create Start Script (Run Server -> Stop -> Backup)
cat << 'EOF' > start_mc.sh
#!/bin/bash
RAM="4096M"
while true; do
    echo ">>> 🟢 STARTING SERVER..."
    java -Xms1024M -Xmx$RAM -XX:+UseG1GC -jar fabric-server-launch.jar nogui
    echo ">>> 🔴 SERVER STOPPED. STARTING BACKUP..."
    ./backup_gdrive.sh
    echo ">>> 🔄 RESTARTING IN 5 SECONDS..."
    sleep 5
done
EOF
chmod +x start_mc.sh

echo ">>> BUILD COMPLETE! Push this to GitHub now."