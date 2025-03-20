#!/bin/bash

# Define directories
DOTFILES="$HOME/.dotfiles"
I3_CONFIG="$HOME/.config/i3"
POLYBAR_CONFIG="$HOME/.config/polybar"

# Ensure dotfiles directory exists
mkdir -p "$DOTFILES/i3"
mkdir -p "$DOTFILES/polybar"

# Backup existing configs if they exist
if [ -d "$I3_CONFIG" ]; then
    echo "Backing up existing i3 config..."
    mv "$I3_CONFIG" "$I3_CONFIG.bak"
fi

if [ -d "$POLYBAR_CONFIG" ]; then
    echo "Backing up existing Polybar config..."
    mv "$POLYBAR_CONFIG" "$POLYBAR_CONFIG.bak"
fi

# Copy configs to dotfiles
echo "Copying i3 config to dotfiles..."
cp -r "$I3_CONFIG.bak"/* "$DOTFILES/i3/"

echo "Copying Polybar config to dotfiles..."
cp -r "$POLYBAR_CONFIG.bak"/* "$DOTFILES/polybar/"

# Create symlinks
echo "Creating symlinks..."
ln -s "$DOTFILES/i3" "$I3_CONFIG"
ln -s "$DOTFILES/polybar" "$POLYBAR_CONFIG"

echo "Dotfiles setup complete! Restart i3 and Polybar for changes to take effect."


