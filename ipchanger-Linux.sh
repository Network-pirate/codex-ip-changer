#!/bin/bash

# ===== Colors =====
GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
NC="\e[0m"

# ===== Trap on Exit (Safe Cleanup) =====
cleanup() {
    echo -e "\n${RED}[!] Exiting... Cleaning up!${NC}"
    pkill -f tor > /dev/null 2>&1
    pkill -f privoxy > /dev/null 2>&1
    reset_proxy
    exit 1
}
trap cleanup INT TERM

# ===== Dependencies =====
echo -e "${YELLOW}[*] Updating and installing dependencies...${NC}"

if command -v apt &> /dev/null; then
    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get install tor privoxy curl netcat-openbsd -y > /dev/null 2>&1
elif command -v dnf &> /dev/null; then
    sudo dnf install tor privoxy curl nmap-ncat -y > /dev/null 2>&1
elif command -v yum &> /dev/null; then
    sudo yum install tor privoxy curl nmap-ncat -y > /dev/null 2>&1
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm tor privoxy curl openbsd-netcat > /dev/null 2>&1
else
    echo -e "${RED}[!] Error: No supported package manager found. Please install tor, privoxy, curl, and netcat manually.${NC}"
    exit 1
fi
echo -e "${GREEN}[+] Dependencies installed successfully!${NC}"

# ===== Detect Netcat Command =====
if command -v nc &> /dev/null; then
    NC_CMD="nc"
elif command -v ncat &> /dev/null; then
    NC_CMD="ncat"
elif command -v netcat &> /dev/null; then
    NC_CMD="netcat"
else
    echo -e "${RED}[!] Netcat not found. Please install it manually.${NC}"
    exit 1
fi

# ===== Kill Old Processes =====
pkill -f tor > /dev/null 2>&1
pkill -f privoxy > /dev/null 2>&1
rm -rf ~/.tor_ipchanger ~/.tor_country ~/.privoxy

# ===== Proxy Setup =====
set_proxy() {
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.system.proxy mode 'manual'
        gsettings set org.gnome.system.proxy.http host '127.0.0.1'
        gsettings set org.gnome.system.proxy.http port 8118
        gsettings set org.gnome.system.proxy.https host '127.0.0.1'
        gsettings set org.gnome.system.proxy.https port 8118
    elif command -v kwriteconfig5 &> /dev/null; then
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key ProxyType 1
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key httpProxy "http://127.0.0.1:8118"
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key httpsProxy "http://127.0.0.1:8118"
    elif command -v xfconf-query &> /dev/null; then
        xfconf-query -c xfce4-session -p /general/HttpProxyHost -s "127.0.0.1"
        xfconf-query -c xfce4-session -p /general/HttpProxyPort -s 8118
    fi
}

reset_proxy() {
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.system.proxy mode 'none'
    elif command -v kwriteconfig5 &> /dev/null; then
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key ProxyType 0
    elif command -v xfconf-query &> /dev/null; then
        xfconf-query -c xfce4-session -p /general/HttpProxyHost -r -R
        xfconf-query -c xfce4-session -p /general/HttpProxyPort -r -R
    fi
}

# ===== Menu Banner =====
clear
echo -e "${GREEN}╔══════════════════════════════════════════╗"
echo -e "${GREEN}║           ${YELLOW}CODEX IP CHANGER${GREEN}               ║"
echo -e "${GREEN}║           ${BLUE} MADE BY TAWHED${GREEN}                ║"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo -e "${YELLOW}[1]${NC} Random IP Rotation"
echo -e "${YELLOW}[2]${NC} Country-Based IP Change"
echo -e "${YELLOW}[3]${NC} Exit"
echo -ne "\n${BLUE}Select an option: ${NC}"
read -r OPTION

# ===== Shared Privoxy Setup =====
start_privoxy() {
  mkdir -p ~/.privoxy
  echo "listen-address 127.0.0.1:8118" > ~/.privoxy/config
  echo "forward-socks5 / 127.0.0.1:9050 ." >> ~/.privoxy/config
  privoxy ~/.privoxy/config > /dev/null 2>&1 &
}

# ===== Wait for Tor to Boot =====
wait_for_tor() {
  for i in {1..20}; do
    if curl --socks5 127.0.0.1:9050 -s https://check.torproject.org/ >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  echo -e "${RED}[!] Tor failed to start.${NC}"
  cleanup
}

# ===== Option 1: Random IP Rotation =====
if [[ "$OPTION" == "1" ]]; then
  mkdir -p ~/.tor_ipchanger/data
  cat <<EOF > ~/.tor_ipchanger/torrc
SocksPort 9050
ControlPort 9051
DataDirectory $HOME/.tor_ipchanger/data
CookieAuthentication 0
EOF

  tor -f ~/.tor_ipchanger/torrc > /dev/null 2>&1 &
  wait_for_tor
  start_privoxy
  set_proxy
  echo -ne "\n${BLUE}Enter rotation interval (in seconds): ${NC}"
  read -r ROTATION_TIME
  [[ "$ROTATION_TIME" -lt 5 ]] && ROTATION_TIME=10

  while true; do
    echo -e "AUTHENTICATE \"\"\nSIGNAL NEWNYM\nQUIT" | $NC_CMD 127.0.0.1 9051 > /dev/null 2>&1
    sleep 3
    NEW_IP=$(curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org)
    echo -e "${GREEN}🌐 New IP: $NEW_IP ✅${NC}"
    echo -e "${BLUE}[Proxy]: 127.0.0.1:8118 🛰️${NC}"
    sleep "$ROTATION_TIME"
  done

# ===== Option 2: Country-Based IP Change =====
elif [[ "$OPTION" == "2" ]]; then
  declare -A countries=(
    [US]="United States" [DE]="Germany" [FR]="France" [IN]="India" [RU]="Russia"
    [CA]="Canada" [UK]="United Kingdom" [JP]="Japan" [CN]="China" [TR]="Turkey"
    [UA]="Ukraine" [AU]="Australia" [BR]="Brazil" [IT]="Italy" [KR]="South Korea"
    [SA]="Saudi Arabia" [SE]="Sweden" [NL]="Netherlands" [NO]="Norway" [ZA]="South Africa"
    [CH]="Switzerland" [MX]="Mexico" [PL]="Poland" [BE]="Belgium" [ES]="Spain"
    [SG]="Singapore" [AR]="Argentina" [BD]="Bangladesh" [PK]="Pakistan" [EG]="Egypt"
    [TH]="Thailand" [ID]="Indonesia" [PH]="Philippines" [VN]="Vietnam" [IR]="Iran"
    [FI]="Finland" [GR]="Greece" [CO]="Colombia" [NZ]="New Zealand" [MY]="Malaysia"
    [RO]="Romania" [HK]="Hong Kong" [IL]="Israel" [HU]="Hungary" [AE]="UAE"
  )

  clear
  echo -e "${BLUE}Available Countries:${NC}"
  for code in "${!countries[@]}"; do
    printf "${GREEN}%-5s${NC} => ${BLUE}%s${NC}\n" "$code" "${countries[$code]}"
  done

  echo -ne "\n${YELLOW}Enter country code (e.g., US, IN): ${NC}"
  read -r COUNTRY
  COUNTRY=$(echo "$COUNTRY" | tr '[:lower:]' '[:upper:]')

  mkdir -p ~/.tor_country/data
  cat <<EOF > ~/.tor_country/torrc
SocksPort 9050
ControlPort 9051
ExitNodes {$COUNTRY}
StrictNodes 1
DataDirectory $HOME/.tor_country/data
CookieAuthentication 0
EOF

  tor -f ~/.tor_country/torrc > /dev/null 2>&1 &
  wait_for_tor
  start_privoxy
  set_proxy
  echo -ne "\n${BLUE}Enter rotation interval (in seconds): ${NC}"
  read -r ROTATION_TIME
  [[ "$ROTATION_TIME" -lt 5 ]] && ROTATION_TIME=10

  while true; do
    echo -e "AUTHENTICATE \"\"\nSIGNAL NEWNYM\nQUIT" | $NC_CMD 127.0.0.1 9051 > /dev/null 2>&1
    sleep 3
    NEW_IP=$(curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org)
    echo -e "${GREEN}🌐 New IP: $NEW_IP ✅${NC}"
    echo -e "${BLUE}[Proxy]: 127.0.0.1:8118 🛰️${NC}"
    sleep "$ROTATION_TIME"
  done

# ===== Option 3: Exit =====
elif [[ "$OPTION" == "3" ]]; then
  echo -e "${GREEN}Goodbye!${NC}"
  reset_proxy
  exit 0
else
  echo -e "${RED}Invalid option.${NC}"
  exit 1
fi
