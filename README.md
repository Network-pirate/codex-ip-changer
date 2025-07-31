# 🛡️ CODEX IP CHANGER

A powerful, dual-platform IP changer for **Termux (Android)**, **Kali/Linux (Desktop)**, and **Windows**.  
Rotate your IP address automatically or by country using the Tor network — with just one click.

> ⚠️ For **educational use only**. Built by **Tawhed** with ❤️ in Termux, Kali & Windows.

---

## 📦 Supported Platforms

| Platform        | Script / File            | Proxy Config         |
|------------------|---------------------------|------------------------|
| Termux (Android) | `ipchanger-termux.sh`     | ✅ Manual Wi-Fi Proxy |
| Kali/Linux       | `ipchanger-kali.sh`       | ✅ Auto Config |
| Windows          | `codex-ipchanger.bat/.exe`| ✅ Auto Config + Restore |

---

## ⚙️ Features

- 🔄 Auto IP rotation via Tor
- 🌍 Country-based IP selection
- ⚙️ Automatic requirement installation
- 🧼 Clean hacker-style output (green IP ✅)
- ☑️ No proxy config needed (Linux + Windows)
- 🪟 Windows version restores settings after exit
- ✅ Fully tested on Termux, Kali, and Windows
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
✅ Proxy is applied automatically  
✅ Ctrl+C restores network defaults

---

### 📱 For Termux (Android):
```bash
./ipchanger-termux.sh
```
⚠️ After running, **go to Wi-Fi settings** and manually set:  
- Proxy: `127.0.0.1`  
- Port: `8118`

---

### 🪟 For Windows:
```bat
codex-ipchanger.exe
```
✅ Runs from terminal or double-click  
✅ Auto applies system proxy using `netsh`  
✅ Auto IP change via Tor + Privoxy  
✅ Menu: Random IP / Country-based / Exit  
✅ On Ctrl+C or closing, **restores proxy to default**  
✅ All traffic is routed system-wide  
✅ No Tor Browser needed  

---

## 📸 Preview Output

```bash
🌐 New IP: 185.220.101.45 ✅
[Proxy]: 127.0.0.1:8118 🛰️
```

---

## 🔌 Stop / Exit

Press `CTRL + C` to stop the script at any time.  
✅ Linux & Windows will automatically revert proxy settings to default.  
⚠️ On Termux, you must disable proxy manually from Wi-Fi settings.

---

## 🛡️ Disclaimer

This tool is provided for **educational** and **cybersecurity learning** purposes only.  
Misuse of this tool and code is not the author’s responsibility.

---

## 👤 Author

- GitHub: [Network-pirate](https://github.com/Network-pirate)
- Coder: **Tawhed**
- Projects: `Codex IP Changer`, `CC-KILLER`, more coming soon!
