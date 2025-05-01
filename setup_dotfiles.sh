#!/bin/bash

# Define directories
DOTFILES="$HOME/dotfiles_v2"
I3_CONFIG="$HOME/.config/i3"
POLYBAR_CONFIG="$HOME/.config/polybar"

# Create symlinks
echo "Creating symlinks..."
ln -s "$DOTFILES/i3" "$I3_CONFIG"
ln -s "$DOTFILES/polybar" "$POLYBAR_CONFIG"

cp /etc/nixos/hardware-configuration.nix .

echo "Dotfiles setup complete! Restart i3 and Polybar for changes to take effect."


