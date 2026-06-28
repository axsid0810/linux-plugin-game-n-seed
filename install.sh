#!/bin/bash

echo "==========================================="
echo "   Installing Game N' Seed Plugin...       "
echo "==========================================="

# 1. Run the base LuaTools-moon installer
echo "-> Installing base plugin framework..."
curl -fsSL https://raw.githubusercontent.com/luatools-linux/luatools-moon/main/install.sh | bash

# 2. Setup a temporary directory for downloading
echo "-> Downloading custom Game N' Seed files..."
mkdir -p /tmp/gamenseed
cd /tmp/gamenseed

# 3. Download and extract your custom zip
curl -L -o plugin.zip https://github.com/axsid0810/linux-plugin-game-n-seed/releases/download/v1.0/plugin.zip
unzip -o plugin.zip

# 4. Copy the files to their specific directories
echo "-> Applying custom patches..."

# Ensure target directories exist just in case
mkdir -p /home/deck/.local/share/Lumen/luatools/public/
mkdir -p /home/deck/.local/share/Lumen/luatools/backend/locales/
mkdir -p /home/deck/.steam/steam/

# Move the files (assuming the files are sitting loosely inside the zip, not inside a subfolder)
cp -f luatools.js /home/deck/.local/share/Lumen/luatools/public/
cp -f icon.ico /home/deck/.local/share/Lumen/luatools/public/
cp -f auto_update.lua /home/deck/.local/share/Lumen/luatools/backend/
cp -f en.json /home/deck/.local/share/Lumen/luatools/backend/locales/
cp -f steam.cfg /home/deck/.steam/steam/

# 5. Clean up the temporary files
echo "-> Cleaning up..."
rm -rf /tmp/gamenseed

echo "==========================================="
echo "   Installation Complete!                  "
echo "   Please fully restart Steam to apply.    "
echo "==========================================="
