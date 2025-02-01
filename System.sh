#!/usr/bin/env sh

# Check if a service name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

SERVICE=$1

# Check service status using systemctl
if systemctl is-active --quiet "$SERVICE"; then
    echo "The service '$SERVICE' is running."
else
    echo "The service '$SERVICE' is NOT running."
fi
