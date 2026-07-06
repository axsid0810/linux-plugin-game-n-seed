#!/bin/bash

echo "==========================================="
echo "   Installing Game N' Seed Plugin...       "
echo "==========================================="

# 1. Detect Operating System and Set Home Directory
echo "-> Detecting Operating System..."

# Failsafe: If the user runs this script with 'sudo', $HOME becomes /root. 
# This grabs the actual user's home directory instead.
if [ -n "$SUDO_USER" ]; then
    CURRENT_USER_HOME=$(eval echo "~$SUDO_USER")
else
    CURRENT_USER_HOME="$HOME"
fi

if grep -iq "steamos" /etc/os-release; then
    echo "   SteamOS detected!"
    TARGET_HOME="/home/deck"
elif grep -iq "bazzite" /etc/os-release; then
    echo "   Bazzite OS detected!"
    TARGET_HOME="$CURRENT_USER_HOME"
else
    echo "   Other OS detected. Falling back to current user."
    TARGET_HOME="$CURRENT_USER_HOME"
fi

echo "   Using Home Directory: $TARGET_HOME"

# 2. Run the base LuaTools-moon installer
echo "-> Installing base plugin framework..."
curl -fsSL https://raw.githubusercontent.com/swwayps/luatools-moon/main/install.sh | bash

# 3. Setup a temporary directory for downloading
echo "-> Downloading custom Game N' Seed files..."
rm -rf /tmp/gamenseed
mkdir -p /tmp/gamenseed
cd /tmp/gamenseed

# 4. Download and extract your custom zip
curl -L -o plugin.zip https://github.com/axsid0810/linux-plugin-game-n-seed/releases/download/v1.0/plugin.zip
unzip -o plugin.zip

# 5. Copy the files to their specific directories
echo "-> Applying custom patches..."

# Ensure all target directories and sub-directories exist
mkdir -p "$TARGET_HOME/.local/share/Lumen/luatools/public/LuaTools/"
mkdir -p "$TARGET_HOME/.local/share/Lumen/luatools/public/luatools/"
mkdir -p "$TARGET_HOME/.local/share/Lumen/luatools/backend/locales/"
mkdir -p "$TARGET_HOME/.steam/steam/"

# Use 'find' so it works even if the files are hidden inside a subfolder in the ZIP
find . -name "luatools.js" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/public/" \;

# Copy icon to all possible paths to guarantee Steam finds it
find . -name "luatools-icon.png" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/public/" \;
find . -name "luatools-icon.png" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/public/LuaTools/" \;
find . -name "luatools-icon.png" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/public/luatools/" \;

find . -name "auto_update.lua" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/backend/" \;
find . -name "api.json" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/backend/" \;
find . -name "en.json" -exec cp -f {} "$TARGET_HOME/.local/share/Lumen/luatools/backend/locales/" \;
find . -name "steam.cfg" -exec cp -f {} "$TARGET_HOME/.steam/steam/" \;

# 6. Update SLSsteam config
echo "-> Configuring SLSsteam..."
CONFIG_FILE="$TARGET_HOME/.config/SLSsteam/config.yaml"

if [ -f "$CONFIG_FILE" ]; then
    # Use sed to find the line starting with PlayNotOwnedGames and replace the whole line
    sed -i 's/^PlayNotOwnedGames:.*/PlayNotOwnedGames: yes/' "$CONFIG_FILE"
    echo "   Successfully set PlayNotOwnedGames to yes."
else
    echo "   Config file not found at $CONFIG_FILE. Skipping this step."
fi

# 7. Clean up the temporary files
echo "-> Cleaning up..."
cd ~
rm -rf /tmp/gamenseed

echo "==========================================="
echo "   Installation Complete!                  "
echo "   Please fully restart Steam to apply.    "
echo "==========================================="
