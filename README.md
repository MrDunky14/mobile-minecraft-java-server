# **🚀 Ultimate Termux Minecraft Server (Fabric 1.21.1)**

**A high-performance, automated Minecraft Server infrastructure designed to run on Android devices (via Termux).**

Features cross-play (Java/Bedrock), automated Google Drive backups, self-healing scripts, and a web-based Admin Dashboard.

## **⚡ Features**

* **Hybrid Architecture:** Builds in **GitHub Codespaces** (CI/CD style), deploys to **Termux** (Android).  
* **Optimized Performance:** Runs on **Fabric 1.21.1** with Lithium, FerriteCore, and ModernFix (Targeting 20 TPS on ARM chips).  
* **Universal Cross-Play:** Native support for **Bedrock Clients** (Mobile/Console) via Geyser & Floodgate.  
* **Automated Ops:**  
  * **Auto-Restart:** Server revives itself if it crashes.  
  * **Cloud Backup:** Automatically zips and syncs world data to **Google Drive** using rclone upon server stop.  
* **Web Dashboard:** Full control via **MCSManager** (Start/Stop, Console, File Manager) accessible remotely.  
* **Networking:** Zero-config tunneling via **Playit.gg** (Static IP, UDP/TCP support).

## **🛠️ Tech Stack**

* **Core:** Minecraft Java Edition (Fabric Loader)  
* **Scripting:** Bash (Automation & Deployment)  
* **Management:** Node.js (MCSManager Dashboard)  
* **Storage:** Rclone (Google Drive API)  
* **Network:** Playit.gg (Global Anycast Tunneling)

## **📂 Project Structure**

├── server/                 \# The core server files  
│   ├── mods/               \# Performance & Gameplay mods (Terralith, Lithium, etc.)  
│   ├── start\_mc.sh         \# Smart launch script (triggers backup on stop)  
│   └── backup\_gdrive.sh    \# Rclone automation script  
├── MCSManager/             \# The Web Dashboard  
├── deploy.sh               \# Master installation script  
└── launch\_host.sh          \# One-click startup script for Termux

## **🚀 Installation Guide**

### **Prerequisites**

1. **Android Device:** 6GB+ RAM recommended (e.g., Poco X5 Pro).  
2. **Termux:** Installed from F-Droid.  
3. **Google Account:** For Drive backups.

### **Phase 1: Deployment (On Termux)**

1. **Update Termux & Install Git:**  
   pkg update \-y && pkg upgrade \-y  
   pkg install git \-y

2. **Clone this Repository:**  
   git clone \[https://github.com/YOUR\_USERNAME/YOUR\_REPO\_NAME.git\](https://github.com/YOUR\_USERNAME/YOUR\_REPO\_NAME.git)  
   cd YOUR\_REPO\_NAME

3. **Run the Installer:**  
   chmod \+x deploy.sh  
   ./deploy.sh

   *This script installs Java 21, Node.js, Rclone, and sets up the environment.*

### **Phase 2: Configuration (First Time Only)**

1. **Link Google Drive (For Backups):**  
   rclone config  
   \# Select 'n' (New Remote) \-\> Name: 'gdrive' \-\> Storage: 'drive' \-\> Follow login steps.

2. **Link Playit (For Public IP):**  
   playit  
   \# Click the link generated to claim your static IP (e.g., agent-mango.gl.joinmc.link).

## **🎮 Usage**

### **Starting the Host**

Run this single command in Termux to start the Dashboard and Tunnel:

cd YOUR\_REPO\_NAME  
./launch\_host.sh

### **Accessing the Dashboard**

1. Open your browser and go to http://localhost:23333 (or your Playit tunnel URL).  
2. **Login:** root / 123456 (Change this immediately\!).  
3. **Start Server:** Navigate to the instance and click **Start**.

### **Stopping & Backup**

* Simply click **Stop** in the Dashboard.  
* The system will automatically trigger backup\_gdrive.sh and upload your world to the cloud.

## **🧩 Mod List**

| Category | Mod | Function |
| :---- | :---- | :---- |
| **Performance** | Lithium | Server Physics Optimization |
| **Performance** | FerriteCore | RAM Usage Reduction |
| **Performance** | ModernFix | Bug Fixes & Launch Speed |
| **Connectivity** | Geyser \+ Floodgate | Bedrock/Pocket Edition Support |
| **World Gen** | Terralith | New Overworld Biomes (Vanilla Blocks) |
| **World Gen** | Incendium | Nether Overhaul |
| **World Gen** | Nullscape | End Overhaul |

## **⚠️ Important Notes**

* **Phantom Process Killer:** On Android 12+, you **MUST** disable the Phantom Process Killer via ADB or the server will be killed by the OS.  
  adb shell "/system/bin/device\_config put activity\_manager max\_phantom\_processes 2147483647"

* **Heat Management:** Keep your device cool\! Heavy chunk generation can cause thermal throttling.

\<p align="center"\>

Created with ❤️ by \<a href="[https://www.google.com/search?q=https://github.com/MrDunky14](https://www.google.com/search?q=https://github.com/MrDunky14)"\>Krishna Singh\</a\>

\</p\>