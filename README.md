# 🛡️ CODEX IP CHANGER - LINUX EDITION

A powerful and clean **Tor-based IP rotation tool** made for **Kali Linux** and **Debian-based systems**.  
Built for privacy, security testing, and online anonymity — without needing to touch Wi-Fi proxy settings manually.

> 🧑‍💻 Made by **Tawhed** • Educational purposes only.

---

## 📸 Preview

```bash
🌐 New IP: 176.57.189.45 ✅
[Proxy]: 127.0.0.1:8118 🛰️
```

---

## 🧠 Features

- ✅ One-click **Auto IP Rotation** using Tor  
- 🌍 **Country-Based Exit Node Selector**  
- ⚙️ Automatically installs all dependencies  
- 🔌 No Wi-Fi or browser proxy setup needed  
- 🧼 Clean output — hacker terminal style  
- 🐧 Made for **Kali Linux / Debian Linux**

---

## 🛠️ Installation

```bash
git clone https://github.com/Network-pirate/codex-ip-changer-linux.git
cd codex-ip-changer-linux
chmod +x ipchanger-kali.sh
./ipchanger-kali.sh
```

> 🔐 Script will auto-install: `tor`, `privoxy`, and `curl`  
> ⚠️ You may be prompted for `sudo` during setup

---

## 🧪 Usage

You’ll get a menu like this:

```bash
==========================================
         CODEX IP CHANGER - LINUX         
           MADE BY TAWHED                 
==========================================

1) Auto-Rotate Random IPs
2) Country-Based IP Selector
3) Exit
```

### ▶ Option 1: Auto-Rotate IPs
- Just enter the rotation interval in seconds (e.g. `5`)
- Tor will refresh and fetch new IP automatically

### 🌍 Option 2: Country-Based IPs
- Select from ISO country codes (e.g. `us`, `fr`, `de`, `ae`)
- Tor will use exit nodes only from that country
- Useful for region testing or bypassing filters

---

## ❓ Troubleshooting

- ❌ If IP doesn't change: some countries have few exit nodes — try another country like `us`, `de`, or `ru`  
- 🔄 If stuck: Press `CTRL+C` to stop script and restart  
- 🌐 Your system’s proxy will reset on exit — no config needed

---

## ⚖️ Disclaimer

This tool is intended for **educational and ethical use only**.  
Any misuse is solely the user's responsibility.

---

## 👑 Author

- GitHub: [Network-pirate](https://github.com/Network-pirate)
- Tool by: **Tawhed**