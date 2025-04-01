#!/usr/bin/env bash

# Installation Script for Lokinet Daemon for macOS
# =====================================
# This install a utility to start/stop Lokinet and remove it's global DNS takeover
# It's directory will be added the shell environment PATH.
# Compatibility Notice:
# This script is designed specifically for macOS.
# Currently only compatible with Bash and Zsh shells.

set -e

INSTALL_DIR="$HOME/.lokinetd-macos"
URL="https://raw.githubusercontent.com/entropi-hk/lokinetd-macos/main/lokinet"
EXECUTABLE_PATH="$INSTALL_DIR/lokinet"
CONFIG_FILES=(".bashrc" ".zshrc")

# Create the utility directory
mkdir -p "$INSTALL_DIR"

# Download the latest executable
echo "📥 Downloading lokinetd-macos..."
echo "ℹ️  Please make sure Lokinet for macOS is installed!"

if command -v curl >/dev/null; then
  curl -fsSL "$URL" -o "$EXECUTABLE_PATH"
elif command -v wget >/dev/null; then
  wget -qO "$EXECUTABLE_PATH" "$URL"
else
  echo "Error: curl or wget is required to install lokinetd-macos utilities." >&2
  exit 1
fi
chmod a+x "$EXECUTABLE_PATH"

echo "✅ lokinetd-macos installed at $EXECUTABLE_PATH"

# Add utility directory to shell configs if not already present
for config in "${CONFIG_FILES[@]}"; do
  config_file="$HOME/$config"
  if [ -f "$config_file" ]; then
    case ":$PATH:" in
      *":$INSTALL_DIR:"*) ;;
      *)
        echo -e "\n# lokinetd-macos\nexport PATH=\"$INSTALL_DIR:\$PATH\"\n" >> "$config_file"
        echo "✅ lokinetd-macos PATH added to $config_file"
        ;;
    esac
  fi
done

echo -e "\n📝 Basic Usage:\n"
echo "lokinet up [LOKINET_PATH] # Starts Lokinet as daemon without taking over all DNS requests. Optionally provide path to Lokinet executable."
echo "lokinet down [LOKINET_PATH] # Stops the Lokinet daemon. Optionally provide path to Lokinet executable."
echo "lokinet update # Update lokinetd-macos to latest version from main branch (todo: versioning)"
echo "lokinet version # View version of currently installed lokinetd-macos"
echo -e "\n🎉 lokinetd-macos successfully installed!"
echo -e "\nPlease restart your shell or run:"
echo "source $config_file"
echo -e "to activate the changes in the current session."
echo -e "\nRun: \`lokinet\` to view all options"
