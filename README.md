# 🛡️ CODEX IP CHANGER  

A powerful, multi-platform IP changer for **Termux (Android)**, **Kali/Linux (Desktop)**, and **Windows**.  
Rotate your IP address automatically or by country using the Tor network — with just one click.  

> ⚠️ **For educational use only.** Built by **Tawhed** with ❤️ in Termux, Kali & Windows.  

---

## 📦 Supported Platforms  

| Platform         | Script / File                      | Proxy Config                             |
|------------------|------------------------------------|-------------------------------------------|
| Termux (Android) | `ipchanger-termux.sh`               | ✅ Manual Wi-Fi Proxy                     |
| Kali/Linux       | `ipchanger-kali.sh`                 | ✅ Manual browser configuration           |
| Windows          | `codex-ipchanger-launcher.bat`      | ✅ Auto Config + Restore                  |

---

## ⚙️ Features  

- 🔄 Auto IP rotation via Tor  
- 🌍 Country-based IP selection  
- ⚙️ Automatic requirement installation  
- 🧼 Clean hacker-style output (green IP ✅)  
- ☑️ No proxy config needed (Windows)  
- 🪟 Windows version restores settings after exit  
- ✅ Fully tested on Termux, Kali, and Windows  
- 🐧 Based on Tor + Privoxy combo  

---

## 🚀 Installation for Linux + Termux  

```bash
apt update && apt upgrade -y
apt install tor -y
apt install privoxy -y
apt install curl -y
apt install netcat git -y
git clone https://github.com/Network-pirate/codex-ip-changer.git
cd codex-ip-changer
chmod +x (according to your device)
```

---

### ▶️ For Kali/Linux:  

```bash
./ipchanger-kali.sh
```

✅ Automatically installs: `tor`, `privoxy`, `curl`  

---

### 🌐 Browser Network Configuration for Linux (Firefox Recommended)  

**You can use any browser that supports manual proxy settings.**  

1. Open Firefox and go to **Settings**.  
2. Scroll to **Network Settings**.  
3. Click **Settings…** (Network Settings dialog).  
4. Select **Manual proxy configuration**.  
5. Set:  
   - **HTTP Proxy**: `127.0.0.1`  
   - **Port**: `8118`  
6. ✅ Check **Use this proxy server for all protocols**.  
7. Leave **No Proxy for** empty.  
8. Click **OK**.  

**⚠ Important:**  
- Keep your tool running in the terminal for the proxy to work.  
- After stopping the tool, remove the proxy settings from Firefox to restore normal internet.  

✅ **Stop the tool:** `CTRL + C`  

---

### 📱 For Termux (Android):  

```bash
./ipchanger-termux.sh
```

⚠ **After running, manually set proxy in Wi-Fi settings:**  
- Proxy: `127.0.0.1`  
- Port: `8118`  

---

### 🪟 For Windows:  

```bat
codex-ipchanger-WINDOWS.exe
```

**Download & Run:**  
1. Click **Code** → Download ZIP.  
2. Extract files.  
3. Run `codex-ipchanger-WINDOWS.exe` as Administrator.  

**Windows Tool Menu:**  
1. **Install Tor** – Install & configure Tor.  
2. **Run Tor** – Starts Tor (minimize the new window, don’t close it).  
3. **Stop Tor** – Stops Tor process.  
4. **Connect Tor with Windows** – Sets Windows proxy to Tor.  
5. **Disconnect Tor from Windows** – Restores default network settings.  
6. **IP Changer Timer** – Set rotation interval (min 15s, can use 10s).  
7. **Start Changing IP** – Begin IP rotation.  
8. **Exit** – Close the tool.  

**How to start (Windows):**  
1. Run **Option 1** (only first time).  
2. Run **Option 2** (keep Tor window open).  
3. Run **Option 4** to connect.  
4. Run **Option 7** to start IP changing.  

**Stopping the tool (Windows):**  
1. Use **Stop Tor** and **Disconnect Tor from Windows** to avoid losing internet.

---
##IMPORTANT NOTE FOR WINDOWS 
   
1. for some coding error and for windows policy I am unable to add **country best IP change option**
2. ** but don't worry I will add the country bes Ip changer option as soon as possible **

---

## 📸 Preview Output  

```bash
🌐 New IP: 185.220.101.45 ✅
[Proxy]: 127.0.0.1:8118 🛰️
```

---

## 🔌 Stop / Exit  

- **Linux & Windows**: `CTRL + C` — automatically restores network settings.  
- **Termux**: Manually disable proxy from Wi-Fi settings after stopping.  

---

## 🛡️ Disclaimer  

This tool is provided for **educational** and **cybersecurity learning** purposes only.  
Misuse of this tool is not the author’s responsibility.  

---

## 👤 Author  

- GitHub: [Network-pirate](https://github.com/Network-pirate)  
- Coder: **Tawhed**  
- Projects: `Codex IP Changer`, `CC-KILLER`, more coming soon!
