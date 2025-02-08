#!/bin/bash

echo "Starting cleanup process..."

# Stop services if they exist
echo "Stopping services..."
sudo systemctl stop wyoming-satellite 2>/dev/null || true
sudo systemctl disable wyoming-satellite 2>/dev/null || true
sudo systemctl stop wyoming-openwakeword 2>/dev/null || true
sudo systemctl disable wyoming-openwakeword 2>/dev/null || true
sudo systemctl stop 2mic_leds 2>/dev/null || true
sudo systemctl disable 2mic_leds 2>/dev/null || true
sudo systemctl stop snapclient 2>/dev/null || true
sudo systemctl disable snapclient 2>/dev/null || true

# Remove systemd service files
echo "Removing systemd service files..."
sudo rm -f /etc/systemd/system/wyoming-satellite.service
sudo rm -f /etc/systemd/system/wyoming-openwakeword.service
sudo rm -f /etc/systemd/system/2mic_leds.service
sudo rm -f /etc/systemd/system/snapclient.service
sudo systemctl daemon-reload

# Removing created directories with sudo to handle permission issues
echo "Removing created directories..."
sudo rm -rf ~/SSV-Setup ~/wyoming-satellite ~/wyoming-openwakeword ~/wyoming-enhancements

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
sudo swapoff /swapfile 2>/dev/null || true
sudo rm -f /swapfile
sudo sed -i '/\/swapfile/d' /etc/fstab

echo "Cleanup complete. The system is now ready for a fresh SSV setup."
