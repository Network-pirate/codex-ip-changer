# 🛡️ CODEX IP CHANGER

A powerful, dual-platform IP changer for **Termux (Android)** and **Kali/Linux (Desktop)**.  
Rotate your IP address automatically or by country using the Tor network — with just one click.

> ⚠️ For **educational use only**. Built by **Tawhed** with ❤️ in Termux & Kali Linux.

---

## 📦 Supported Platforms

| Platform     | Script                | Proxy Config |
|--------------|------------------------|------------------|
| Termux (Android) | `ipchanger-termux.sh` | ✅ Manual Wi-Fi Proxy |
| Kali/Linux   | `ipchanger-kali.sh`     | ❌ No config needed |

---

## ⚙️ Features

- 🔄 Auto IP rotation via Tor
- 🌍 Country-based IP selection
- ⚙️ Automatic requirement installation
- 🧼 Clean hacker-style output (green IP ✅)
- ☑️ No proxy config needed for Linux
- ✅ Fully tested on Termux and Kali
- 🐧 Based on Tor + Privoxy combo

---

## 🚀 Installation

```bash
git clone https://github.com/Network-pirate/codex-ip-changer.git
cd codex-ip-changer
chmod +x ipchanger-*.sh
```

---

### ▶️ For Kali/Linux:
```bash
./ipchanger-kali.sh
```
✅ Automatically installs: `tor`, `privoxy`, `curl`  
✅ No need to manually set system proxy

---

### 📱 For Termux (Android):
```bash
./ipchanger-termux.sh
```
⚠️ After running, **go to Wi-Fi settings** and manually set:  
- Proxy: `127.0.0.1`  
- Port: `8118`

---

## 📸 Preview Output

```bash
🌐 New IP: 185.220.101.45 ✅
[Proxy]: 127.0.0.1:8118 🛰️
```

---

## 🔌 Stop / Exit

Press `CTRL + C` to stop the script at any time.  
Network returns to default automatically.

---

## 🛡️ Disclaimer

This tool is provided for **educational** and **cybersecurity learning** purposes only.  
Misuse of this tool and cod is not the author’s responsibility.

---

## 👤 Author

- GitHub: [Network-pirate](https://github.com/Network-pirate)
- Coder: **Tawhed**
- Projects: `Codex IP Changer`, `CC-KILLER`, more coming soon!
