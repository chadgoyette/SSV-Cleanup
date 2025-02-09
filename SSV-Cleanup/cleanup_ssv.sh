#!/bin/bash
set -euo pipefail

echo "Starting cleanup process..."

# Stop services if they exist
echo "Stopping services..."
sudo systemctl stop wyoming-satellite || true
sudo systemctl disable wyoming-satellite || true

sudo systemctl stop wyoming-openwakeword || true
sudo systemctl disable wyoming-openwakeword || true

sudo systemctl stop 2mic_leds.service || true
sudo systemctl disable 2mic_leds.service || true

sudo systemctl stop snapclient || true
sudo systemctl disable snapclient || true

# Remove systemd service files
echo "Removing systemd service files..."
sudo rm -f /etc/systemd/system/wyoming-satellite.service
sudo rm -f /etc/systemd/system/wyoming-openwakeword.service
sudo rm -f /etc/systemd/system/2mic_leds.service
sudo rm -f /etc/systemd/system/snapclient.service
sudo systemctl daemon-reload

# Removing created directories with sudo to handle permission issues
echo "Removing created directories..."
rm -rf ~/wyoming-satellite
rm -rf ~/wyoming-openwakeword
rm -rf ~/wyoming-enhancements
rm -f ~/ssv_config.cfg

sudo rm -f /etc/pulse/system.pa
sudo systemctl restart pulseaudio  # Restart PulseAudio after removal

sudo rm -f /etc/default/snapclient

# Remove directories created by SSV setup
echo "Removing created directories..."
rm -rf ~/wyoming-satellite
rm -rf ~/wyoming-openwakeword
rm -rf ~/wyoming-enhancements
rm -rf ~/SSV-Setup
rm -rf ~/snapclient
rm -rf ~/venv
rm -rf ~/.venv

# Remove log files and progress tracking files
echo "Removing log files and progress files..."
sudo rm -f /var/log/ssv_setup.log
rm -f ~/.ssv_progress

# Reset Swapfile if created
echo "Resetting swapfile..."
if [ -f "/swapfile" ]; then
    sudo swapoff /swapfile
    sudo rm -f /swapfile
    sudo sed -i '/\/swapfile/d' /etc/fstab
fi

sudo apt autoremove -y

echo "Cleanup complete. The system is now ready for a fresh SSV setup."
