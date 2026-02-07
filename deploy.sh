#!/bin/bash
# 🛠️ FIXED DEPLOY SCRIPT (Handles Playit + Git Login Issues)

echo ">>> [1/5] Installing Dependencies..."
pkg update -y
pkg install openjdk-21 nodejs wget tar rclone git gnupg -y

echo ">>> [2/5] Setting up Playit.gg (Fixing 'Not Found' Error)..."
# 1. Add Playit GPG Key
curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee $PREFIX/etc/apt/trusted.gpg.d/playit.gpg >/dev/null
# 2. Add Playit Repo
echo "deb [signed-by=$PREFIX/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee $PREFIX/etc/apt/sources.list.d/playit-cloud.list
# 3. Update & Install
pkg update -y
pkg install playit -y

echo ">>> [3/5] Cloning Server..."
echo "--------------------------------------------------------"
echo "⚠️ IMPORTANT: Copy your Repo URL from GitHub!"
echo "It should look like: https://github.com/cool-mango/my-server.git"
echo "--------------------------------------------------------"
read -p "Paste your Repo URL here: " REPO_URL

# Clone using the URL you pasted
git clone "$REPO_URL" mc_ultimate

# Check if clone worked
if [ ! -d "mc_ultimate" ]; then
    echo "❌ Git Clone Failed! Check your URL."
    echo "Make sure the Repo is PUBLIC on GitHub."
    exit 1
fi

cd mc_ultimate

# Fix permissions
chmod +x server/start_mc.sh
chmod +x server/backup_gdrive.sh

echo ">>> [4/5] Installing Dashboard (MCSManager)..."
if [ ! -d "MCSManager" ]; then
    git clone https://github.com/MCSManager/MCSManager.git
    cd MCSManager
    npm install --production
    cd ..
fi

echo ">>> [5/5] Creating Host Launcher..."
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

echo "✅ FIXED DEPLOYMENT COMPLETE!"
echo "Run './launch_host.sh' to start."