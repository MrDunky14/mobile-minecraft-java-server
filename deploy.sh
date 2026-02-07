#!/bin/bash
# 🚀 TERMUX DEPLOY SCRIPT
# Clones your repo, installs Java/Node, MCSManager, and Playit.

# REPLACE THIS WITH YOUR REPO URL!
REPO_URL="https://github.com/YOUR_USERNAME/my-server-build.git"

echo ">>> [1/4] Installing System Dependencies..."
pkg update -y
pkg install openjdk-21 nodejs git wget tar rclone playit -y

echo ">>> [2/4] Cloning Your Server Build..."
git clone $REPO_URL mc_ultimate
cd mc_ultimate

# Fix permissions lost during git transfer
chmod +x server/start_mc.sh
chmod +x server/backup_gdrive.sh

echo ">>> [3/4] Installing Dashboard UI (MCSManager)..."
if [ ! -d "MCSManager" ]; then
    git clone https://github.com/MCSManager/MCSManager.git
    cd MCSManager
    npm install --production
    cd ..
fi

echo ">>> [4/4] Creating 'One-Click' Host Script..."
cat << 'EOF' > launch_host.sh
#!/bin/bash
echo ">>> STARTING DASHBOARD (Background)..."
cd ~/mc_ultimate/MCSManager
nohup npm start > /dev/null 2>&1 &
echo ">>> STARTING TUNNEL (Playit)..."
echo "------------------------------------------------"
echo "✅ HOST ONLINE!"
echo "📱 Dashboard: http://localhost:23333"
echo "🔑 Login:     root / 123456"
echo "------------------------------------------------"
playit
EOF
chmod +x launch_host.sh

echo ">>> DEPLOYMENT FINISHED!"
echo "Run './launch_host.sh' inside the folder to start."