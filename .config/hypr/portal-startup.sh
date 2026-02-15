#!/bin/bash

# Wait for Hyprland to fully initialize
sleep 3

# Kill any existing portals
killall xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal 2>/dev/null

# Set environment
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland

# Ensure DBus session is correct
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Start portals in correct order
/usr/lib/xdg-desktop-portal -r &
PORTAL_PID=$!

# Wait for main portal to initialize
sleep 3

# Start Hyprland portal if main portal is running
if kill -0 $PORTAL_PID 2>/dev/null; then
    /usr/lib/xdg-desktop-portal-hyprland &
    HYPR_PID=$!
    sleep 2
    
    if kill -0 $HYPR_PID 2>/dev/null; then
        echo "Portals started successfully" > /tmp/portals-status
    else
        echo "Failed to start Hyprland portal" > /tmp/portals-status
    fi
else
    echo "Failed to start main portal" > /tmp/portals-status
fi
