#!/bin/bash

# ===== Colors =====
GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
NC="\e[0m"

# ===== Globals (do NOT change) =====
TOR_PID=""
PRIVOXY_PID=""
NC_CMD=""

# ===== Trap on Exit (Safe Cleanup) =====
cleanup() {
    echo -e "\n${RED}[!] Exiting... Cleaning up!${NC}"
    # kill only processes we started
    if [[ -n "$PRIVOXY_PID" ]]; then kill "$PRIVOXY_PID" > /dev/null 2>&1 || true; fi
    if [[ -n "$TOR_PID" ]]; then kill "$TOR_PID" > /dev/null 2>&1 || true; fi
    reset_proxy
    exit 1
}
trap cleanup INT TERM

# ===== Dependencies =====
echo -e "${YELLOW}[*] Updating and installing dependencies...${NC}"

if command -v apt &> /dev/null; then
    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get install -y tor privoxy curl netcat-openbsd xxd >/dev/null 2>&1 || sudo apt-get install -y tor privoxy curl netcat-openbsd >/dev/null 2>&1
elif command -v dnf &> /dev/null; then
    sudo dnf install -y tor privoxy curl nmap-ncat xxd >/dev/null 2>&1 || sudo dnf install -y tor privoxy curl nmap-ncat >/dev/null 2>&1
elif command -v yum &> /dev/null; then
    sudo yum install -y tor privoxy curl nmap-ncat xxd >/dev/null 2>&1 || sudo yum install -y tor privoxy curl nmap-ncat >/dev/null 2>&1
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm tor privoxy curl openbsd-netcat xxd >/dev/null 2>&1 || sudo pacman -Sy --noconfirm tor privoxy curl openbsd-netcat >/dev/null 2>&1
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

# ===== Kill Old Data (only our folders) =====
rm -rf "$HOME/.tor_ipchanger" "$HOME/.tor_country" "$HOME/.privoxy" 2>/dev/null || true

# ===== Proxy Setup =====
set_proxy() {
    # GUI DE proxies
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.system.proxy mode 'manual' >/dev/null 2>&1 || true
        gsettings set org.gnome.system.proxy.http host '127.0.0.1' >/dev/null 2>&1 || true
        gsettings set org.gnome.system.proxy.http port 8118 >/dev/null 2>&1 || true
        gsettings set org.gnome.system.proxy.https host '127.0.0.1' >/dev/null 2>&1 || true
        gsettings set org.gnome.system.proxy.https port 8118 >/dev/null 2>&1 || true
    elif command -v kwriteconfig5 &> /dev/null; then
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key ProxyType 1 >/dev/null 2>&1 || true
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key httpProxy "http://127.0.0.1:8118" >/dev/null 2>&1 || true
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key httpsProxy "http://127.0.0.1:8118" >/dev/null 2>&1 || true
    elif command -v xfconf-query &> /dev/null; then
        xfconf-query -c xfce4-session -p /general/HttpProxyHost -s "127.0.0.1" >/dev/null 2>&1 || true
        xfconf-query -c xfce4-session -p /general/HttpProxyPort -s 8118 >/dev/null 2>&1 || true
    fi

    # CLI env proxy for curl/wget etc.
    export http_proxy="http://127.0.0.1:8118"
    export https_proxy="http://127.0.0.1:8118"
}

reset_proxy() {
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.system.proxy mode 'none' >/dev/null 2>&1 || true
    elif command -v kwriteconfig5 &> /dev/null; then
        kwriteconfig5 --file kioslaverc --group 'Proxy Settings' --key ProxyType 0 >/dev/null 2>&1 || true
    elif command -v xfconf-query &> /dev/null; then
        xfconf-query -c xfce4-session -p /general/HttpProxyHost -r -R >/dev/null 2>&1 || true
        xfconf-query -c xfce4-session -p /general/HttpProxyPort -r -R >/dev/null 2>&1 || true
    fi

    unset http_proxy https_proxy
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
  mkdir -p "$HOME/.privoxy"
  echo "listen-address 127.0.0.1:8118" > "$HOME/.privoxy/config"
  echo "forward-socks5 / 127.0.0.1:9050 ." >> "$HOME/.privoxy/config"
  privoxy "$HOME/.privoxy/config" > /dev/null 2>&1 &
  PRIVOXY_PID=$!
}

# ===== Wait for Tor readiness =====
wait_for_tor_sock_and_cookie() {
  local data_dir="$1"
  local tries=30
  local attempt=0

  # wait for SOCKS port to be listening
  while [[ $attempt -lt $tries ]]; do
    if command -v ss &> /dev/null; then
      ss -ltn | grep -q ":9050" && break
    else
      netstat -ltn 2>/dev/null | grep -q ":9050" && break
    fi
    sleep 1
    ((attempt++))
  done

  # wait for control cookie file
  attempt=0
  while [[ $attempt -lt $tries ]]; do
    if [[ -f "$data_dir/control_auth_cookie" ]]; then
      return 0
    fi
    sleep 1
    ((attempt++))
  done

  return 1
}

# ===== Send control command (uses cookie auth) =====
tor_control_newnym() {
  local data_dir="$1"
  local cookie_file="$data_dir/control_auth_cookie"
  if [[ ! -f "$cookie_file" ]]; then
    return 1
  fi

  # get cookie hex (portable)
  if command -v xxd &> /dev/null; then
    cookie_hex=$(xxd -p -c 256 "$cookie_file")
  else
    cookie_hex=$(hexdump -v -e '/1 "%02x"' "$cookie_file")
  fi

  printf 'AUTHENTICATE %s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' "$cookie_hex" | $NC_CMD 127.0.0.1 9051 > /dev/null 2>&1
  return $?
}

# ===== fetch IP via privoxy (safe) =====
fetch_ip() {
  curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org || true
}

# ===== Option 1: Random IP Rotation =====
if [[ "$OPTION" == "1" ]]; then
  data_dir="$HOME/.tor_ipchanger/data"
  mkdir -p "$data_dir"
  cat <<EOF > "$HOME/.tor_ipchanger/torrc"
SocksPort 9050
ControlPort 9051
DataDirectory $data_dir
CookieAuthentication 1
EOF

  tor -f "$HOME/.tor_ipchanger/torrc" > /dev/null 2>&1 &
  TOR_PID=$!
  # wait for tor sock and cookie
  if ! wait_for_tor_sock_and_cookie "$data_dir"; then
    echo -e "${RED}[!] Tor failed to start or create control cookie.${NC}"
    cleanup
  fi

  start_privoxy
  set_proxy
  echo -ne "\n${BLUE}Enter rotation interval (in seconds): ${NC}"
  read -r ROTATION_TIME
  [[ "$ROTATION_TIME" -lt 5 ]] && ROTATION_TIME=10

  while true; do
    # newnym via control cookie
    if ! tor_control_newnym "$data_dir"; then
      echo -e "${YELLOW}[!] WARNING: failed to signal NEWNYM. Retrying...${NC}"
    fi
    sleep 3
    NEW_IP=$(fetch_ip)
    [[ -z "$NEW_IP" ]] && NEW_IP="(no response)"
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

  data_dir="$HOME/.tor_country/data"
  mkdir -p "$data_dir"
  cat <<EOF > "$HOME/.tor_country/torrc"
SocksPort 9050
ControlPort 9051
ExitNodes {$COUNTRY}
StrictNodes 1
DataDirectory $data_dir
CookieAuthentication 1
EOF

  tor -f "$HOME/.tor_country/torrc" > /dev/null 2>&1 &
  TOR_PID=$!

  if ! wait_for_tor_sock_and_cookie "$data_dir"; then
    echo -e "${RED}[!] Tor failed to start with requested ExitNodes. Retrying without StrictNodes...${NC}"
    # fallback: remove StrictNodes and ExitNodes and restart tor in random mode
    kill "$TOR_PID" >/dev/null 2>&1 || true
    sleep 1
    cat <<EOF > "$HOME/.tor_country/torrc"
SocksPort 9050
ControlPort 9051
DataDirectory $data_dir
CookieAuthentication 1
EOF
    tor -f "$HOME/.tor_country/torrc" > /dev/null 2>&1 &
    TOR_PID=$!
    if ! wait_for_tor_sock_and_cookie "$data_dir"; then
      echo -e "${RED}[!] Tor still failed to start. Aborting.${NC}"
      cleanup
    fi
  fi

  start_privoxy
  set_proxy
  echo -ne "\n${BLUE}Enter rotation interval (in seconds): ${NC}"
  read -r ROTATION_TIME
  [[ "$ROTATION_TIME" -lt 5 ]] && ROTATION_TIME=10

  while true; do
    if ! tor_control_newnym "$data_dir"; then
      echo -e "${YELLOW}[!] WARNING: failed to signal NEWNYM. Retrying...${NC}"
    fi
    sleep 3
    NEW_IP=$(fetch_ip)
    [[ -z "$NEW_IP" ]] && NEW_IP="(no response)"
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
