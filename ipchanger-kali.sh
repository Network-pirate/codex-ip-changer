#!/bin/bash

# CODEx IP CHANGER - KALI LINUX EDITION
# Made by Tawhed | Linux Version

# Required services
TORRC_PATH="/etc/tor/torrc"
PRIVOXY_CONFIG="/etc/privoxy/config"
ROTATION_TIME=5

# Colors
GREEN="\e[1;32m"
BLUE="\e[1;34m"
NC="\e[0m"

# Function: Show new IP
function show_ip() {
    NEW_IP=$(curl -s --socks5 127.0.0.1:9050 https://api.ipify.org)
    echo -e "${GREEN}🌐 New IP: $NEW_IP ✅${NC}"
    echo -e "${BLUE}[Proxy]: 127.0.0.1:8118 🛰️${NC}"
    echo
}

# Function: Start services
function start_services() {
    sudo systemctl start tor
    sudo systemctl start privoxy
    sleep 3
}

# Function: Auto-Rotate IP
function auto_rotate() {
    echo -ne "\nEnter rotation interval (in seconds): "
    read -r ROTATION_TIME
    while true; do
        sudo systemctl restart tor
        sleep 8
        show_ip
        sleep "$ROTATION_TIME"
    done
}

# Function: Country-based IP rotation
function country_ip() {
    echo -ne "\nEnter country code (e.g. us, de, fr): "
    read -r COUNTRY

    # Update torrc with new ExitNode
    sudo sed -i '/^ExitNodes/d' "$TORRC_PATH"
    sudo sed -i '/^StrictNodes/d' "$TORRC_PATH"
    echo "ExitNodes {$COUNTRY}" | sudo tee -a "$TORRC_PATH" > /dev/null
    echo "StrictNodes 1" | sudo tee -a "$TORRC_PATH" > /dev/null

    sudo systemctl restart tor
    sleep 10

    echo -ne "\nEnter rotation interval (in seconds): "
    read -r ROTATION_TIME

    while true; do
        sudo systemctl restart tor
        sleep 8
        show_ip
        sleep "$ROTATION_TIME"
    done
}

# Main Menu
clear
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}         CODEX IP CHANGER - LINUX         ${NC}"
echo -e "${GREEN}           MADE BY TAWHED                 ${NC}"
echo -e "${GREEN}==========================================${NC}"
echo -e "\n1) Auto-Rotate Random IPs"
echo -e "2) Country-Based IP Selector"
echo -e "3) Exit"
echo -ne "\nChoose an option: "
read -r CHOICE

start_services

if [[ "$CHOICE" == "1" ]]; then
    auto_rotate
elif [[ "$CHOICE" == "2" ]]; then
    country_ip
else
    echo -e "\n${BLUE}Exiting...${NC}"
    exit 0
fi