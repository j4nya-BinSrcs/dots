#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  THE DOTS — modules/waybar/scripts/toggle-perf.sh            ║
# ╠══════════════════════════════════════════════════════════════╣
# ║  Purpose : Toggle the performance stats drawer in Waybar.    ║
# ║            Writes state to a file, then swaps Waybar configs  ║
# ║            between the default and a perf-expanded variant.  ║
# ╚══════════════════════════════════════════════════════════════╝

STATE_FILE="$HOME/.cache/waybar-perf-state"
CONFIG_DIR="$HOME/.config/waybar"

# Read current state (default: hidden)
if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "visible" ]]; then
    # Currently visible → hide perf modules
    echo "hidden" > "$STATE_FILE"
    # Swap to the compact config (no perf modules in modules-right)
    cp "$CONFIG_DIR/config-compact.jsonc" "$CONFIG_DIR/config.jsonc.active"
else
    # Currently hidden → show perf modules
    echo "visible" > "$STATE_FILE"
    # Swap to the full config (perf modules included)
    cp "$CONFIG_DIR/config-perf.jsonc" "$CONFIG_DIR/config.jsonc.active"
fi

# Reload Waybar gracefully (SIGUSR2 = reload style, kill+restart = full reload)
# We use kill -SIGUSR2 for style-only, or full restart for module changes.
pkill -SIGUSR2 waybar 2>/dev/null || true

# If SIGUSR2 didn't work (some versions need full restart):
# pkill waybar && sleep 0.1 && waybar &
