#!/bin/bash

echo "==========================================="
echo "   Installing Game N' Seed Plugin...       "
echo "==========================================="

# 1. Run the base LuaTools-moon installer
echo "-> Installing base plugin framework..."
curl -fsSL https://raw.githubusercontent.com/swwayps/luatools-moon/main/install.sh | bash

# 2. Setup a temporary directory for downloading
echo "-> Downloading custom Game N' Seed files..."
rm -rf /tmp/gamenseed
mkdir -p /tmp/gamenseed
cd /tmp/gamenseed

# 3. Download and extract your custom zip
curl -L -o plugin.zip https://github.com/axsid0810/linux-plugin-game-n-seed/releases/download/v1.0/plugin.zip
unzip -o plugin.zip

# 4. Copy the files to their specific directories
echo "-> Applying custom patches..."

# Ensure all target directories and sub-directories exist
mkdir -p /home/deck/.local/share/Lumen/luatools/public/LuaTools/
mkdir -p /home/deck/.local/share/Lumen/luatools/public/luatools/
mkdir -p /home/deck/.local/share/Lumen/luatools/backend/locales/
mkdir -p /home/deck/.steam/steam/

# Use 'find' so it works even if the files are hidden inside a subfolder in the ZIP
find . -name "luatools.js" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/public/ \;

# Copy icon to all possible paths to guarantee Steam finds it
find . -name "luatools-icon.png" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/public/ \;
find . -name "luatools-icon.png" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/public/LuaTools/ \;
find . -name "luatools-icon.png" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/public/luatools/ \;

find . -name "auto_update.lua" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/backend/ \;
find . -name "api.json" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/backend/ \;
find . -name "en.json" -exec cp -f {} /home/deck/.local/share/Lumen/luatools/backend/locales/ \;
find . -name "steam.cfg" -exec cp -f {} /home/deck/.steam/steam/ \;

# 5. Update SLSsteam config
echo "-> Configuring SLSsteam..."
CONFIG_FILE="/home/deck/.config/SLSsteam/config.yaml"

if [ -f "$CONFIG_FILE" ]; then
    # Use sed to find the line starting with PlayNotOwnedGames and replace the whole line
    sed -i 's/^PlayNotOwnedGames:.*/PlayNotOwnedGames: yes/' "$CONFIG_FILE"
    echo "   Successfully set PlayNotOwnedGames to yes."
else
    echo "   Config file not found at $CONFIG_FILE. Skipping this step."
fi

# 6. Clean up the temporary files
echo "-> Cleaning up..."
cd ~
rm -rf /tmp/gamenseed

echo "==========================================="
echo "   Installation Complete!                  "
echo "   Please fully restart Steam to apply.    "
echo "==========================================="
